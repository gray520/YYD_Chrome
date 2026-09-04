# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import os
import re
import subprocess

from cros.factory.device import device_utils
from cros.factory.test import device_data
from cros.factory.test import session
from cros.factory.test import test_case
from cros.factory.test.i18n import _
from cros.factory.utils import process_utils
from cros.factory.utils.arg_utils import Arg
#from .edid import *


class HardwareCheck(test_case.TestCase):
  ARGS = [
    Arg('check_cpu_model', bool,
        'Check CPU type is the same as the shopfloor system definition.',
        default=True),
    Arg('check_memory_size', bool,
        'Check memory size is the same as the shopfloor system definition.',
        default=True),
    Arg('check_lcd_pid', bool, 'Check LCD PID Type same as shopfloor system.',
        default=False),
    Arg('check_storage_size', bool,
        'Check storage size is the same as the shopfloor system definition.',
        default=True),
    Arg('check_display_type', bool,
        'Check display type is the same as shopfloor system definition.',
        default=False)
  ]

  def setUp(self):
    self.dut = device_utils.CreateDUTInterface()
    self.ui.ToggleTemplateClass('font-large', True)

  def runTest(self):
    if self.args.check_cpu_model:
      self.CheckCPUModel()
    if self.args.check_memory_size:
      self.CheckMemorySize()
    if self.args.check_storage_size:
      self.CheckStorageSize()
    if self.args.check_display_type:
      self.CheckDisplayType()
    if self.args.check_lcd_pid:
      self.CheckLCDPID()

  def CheckCPUModel(self):
    """Only for x86 CPU type."""
    defined_cpu_model = str(device_data.GetDeviceData('component.cpu_model'))
    session.console.info('Shopfloor defined CPU model is %s', defined_cpu_model)
    cmd = r'sed -nr "s/^model name\s*: (.*)/\1/p" /proc/cpuinfo'
    stdout = process_utils.CheckOutput(cmd, shell=True, log=True).splitlines()
    dut_cpu_model = stdout[0].strip()
    session.console.info('DUT CPU model is %s', dut_cpu_model)
    if dut_cpu_model != defined_cpu_model:
      session.console.error('DUT CPU model %s different with shopfloor defined '
                            'CPU model %s.', defined_cpu_model, dut_cpu_model)
      self.ui.SetState([
        '<span class="test-error">',
        _('Check CPU model failed, DUT CPU model different with shopfloor defined'
          ' CPU model, Auto-testing stopped.<br><br>'
          'Please check device hardware and call software engineer!<br>'),
        '</span>'
      ])
      self.WaitTaskEnd()
    else:
      session.console.info('Check CPU Model Passed!')

  def CheckMemorySize(self):
    ret = process_utils.CheckOutput(
      ['mosys', '-k', 'memory', 'spd', 'print', 'geometry'])
    mosys_mem_mb = sum([int(x) for x in re.findall('size_mb="([^"]*)"', ret)])
    #mosys_mem_ranks = sum([int(x) for x in re.findall('ranks="([^"]*)"', ret)])
    mosys_mem_gb = round(mosys_mem_mb / 1024.0, 1)
    session.console.info(
      'Memory size detected with mosys (%.1f GB)' % mosys_mem_gb)
    defined_mem_gb = round(float(device_data.GetDeviceData(
      'component.memory_size')), 1)
    session.console.info(
      'Shopfloor defined memory size is (%.1f GB).' % defined_mem_gb)
    if abs(mosys_mem_gb - defined_mem_gb) > 10e-6:
      session.console.error('Check memory size failed, DUT memory size %s '
                            'different with shopfloor defined memory size %s.',
                            mosys_mem_gb, defined_mem_gb)
      self.ui.SetState([
        '<span class="test-error">',
        _('DUT memory size different with shopfloor defined memory size, '
          'Auto-testing stopped.<br><br>'
          'Please check device hardware and call software engineer!<br>'),
        '</span>'
      ])
      self.WaitTaskEnd()
    else:
      session.console.info('Check Memory Size Passed!')

  def CheckStorageSize(self):
    if os.path.exists('/sys/block/mmcblk0/size') is True:
      block_path = '/sys/block/mmcblk0/size'
      hw_sector_path = '/sys/block/mmcblk0/queue/hw_sector_size'
    elif os.path.exists('/sys/block/mmcblk1/size') is True:
      block_path = '/sys/block/mmcblk1/size'
      hw_sector_path = '/sys/block/mmcblk1/queue/hw_sector_size'
    elif os.path.exists('/sys/block/nvme0n1/size') is True:
      block_path = '/sys/block/nvme0n1/size'
      hw_sector_path = '/sys/block/nvme0n1/queue/hw_sector_size'
    else:
      block_path = '/sys/block/sda/size'
      hw_sector_path = '/sys/block/sda/queue/hw_sector_size'

    if os.path.exists('/sys/block/sda/size') is True:
      with open(block_path) as f, open(hw_sector_path) as fp:
        sectors = f.read()
        sector_size = fp.read()
        dut_storage_size = round(
          float(sectors) / float(sector_size)) / 512
      session.console.info('DUT storage size is (%.1f GB)' % dut_storage_size)
    else:
      with open(block_path) as f, open(hw_sector_path) as fp:
        sectors = f.read()
        sector_size = fp.read()
        dut_storage_size = round(
          float(sectors) * float(sector_size)) / (1024.0 * 1024.0 * 1024.0)
      session.console.info('DUT storage size is (%.1f GB)' % dut_storage_size)
        
    if os.path.exists('/sys/block/nvme0n1/size') is True:
      defined_storage_size = round(
        float(device_data.GetDeviceData('component.storage_size')), 1)
    else:
      defined_storage_size = round(
        float(device_data.GetDeviceData('component.storage_size')), 1)
    session.console.info(
      'Shopfloor defined storage size is (%.1f GB)' % defined_storage_size)

    if abs(dut_storage_size - defined_storage_size) > abs(
      defined_storage_size * 0.091):
      session.console.error('Check storage size failed, DUT storage size %s '
                            'different with shopfloor defined storage size %s.',
                            dut_storage_size, defined_storage_size)
      self.ui.SetState([
        '<span class="test-error">',
        _('Check storage failed, DUT storage size different with '
          'shopfloor defined storage size, Auto-testing stopped.<br><br>'
          'Please check device hardware and call software engineer!<br>'),
        '</span>'
      ])
      self.WaitTaskEnd()
    else:
      session.console.info('Check Storage Size Passed!')

  def CheckDisplayType(self):
    defined_display_type = str(device_data.GetDeviceData('component.lcd_type'))
    if 'FHD' in defined_display_type:
      shopfloor_display_type = 'FHD'
    elif 'QHD' in defined_display_type:
      shopfloor_display_type = 'QHD'
    else:
      session.console.info(
        'Shopfloor display type not defined, Use default HD type check!')
      shopfloor_display_type = 'HD'
    session.console.info('Shpfloor Display type is %s', shopfloor_display_type)

    cmd = r'modetest | grep preferred'
    stdout = process_utils.CheckOutput(cmd, shell=True, log=True).splitlines()
    dut_display_size = stdout[0].strip().split()[0]
    dut_display_type = ''
    if dut_display_size == '2256x1504':
      dut_display_type = 'QHD'
    elif dut_display_size == '1920x1080':
      dut_display_type = 'FHD'
    elif dut_display_size == '1366x768' or dut_display_size == '1366x912':
      dut_display_type = 'HD'
    else:
      session.console.error('Can not detect display info!')

    if dut_display_type != shopfloor_display_type:
      session.console.error('Check display type failed, DUT display type %s '
                            'different with shopfloor defined display type %s.',
                            dut_display_type, defined_display_type)
      self.ui.SetState([
        '<span class="test-error">',
        _('Check display type failed, DUT display type different with '
          'shopfloor defined display type, Auto-testing stopped.<br><br>'
          'Please check device hardware and call software engineer!<br>'),
        '</span>'
      ])
      self.WaitTaskEnd()
    else:
      session.console.info('Check Display Type Passed!')

  def CheckLCDPID(self):
    sf_defined_pid = str(device_data.GetDeviceData('component.chrome_lcd_pid'))
    sf_pid = sf_defined_pid
    session.console.info('Shpfloor LCD type is %s', sf_pid)
    edid_tool=EDIDFunction()
    dut_pid=edid_tool.Probe()[0]['product_id']
    vendor=edid_tool.Probe()[0]['vendor']
    dut_info = vendor + dut_pid
    print(dut_pid) 
    print(vendor) 
    if dut_info == '':
      session.console.info('Can\'t detect display size info!')

    #if sf_pid != dut_info:
    if str.lower(sf_pid) != str.lower(dut_info):
      session.console.info('DUT LCD type is %s',  dut_info)
      msg = ('Shpfloor LCD type not match as DUT LCD, please Call PD Team!')
      self.fail(msg)
    else:
      session.console.info(
        'DUT LCD type is %s, Same as Shopfloor LCD type, Check Passed!',
        dut_info)
