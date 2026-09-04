#!/usr/bin/python
# coding=utf-8

"""
Check cr50 board id value id 'ffffffff' or '00007f80' for spare part process
To run this test on DUT, add a test item in the test list:

  {
    "pytest_name": "board_id_check",
    "run_if": "device.component.is_spare_part"
  }
"""

import os
import time
import functools

from cros.factory.device import device_utils
from cros.factory.gooftool import common as gooftool_common
from cros.factory.external.chromeos_cli import gsctool
#from cros.factory.test.utils.gsc_utils import GSCUtils
from cros.factory.test import session
from cros.factory.test import state
from cros.factory.test import test_case
from cros.factory.test.i18n import _
from cros.factory.utils.arg_utils import Arg


class Cr50BoardIDCheck(test_case.TestCase):
  ARGS = [
    Arg('check_cr50_board_id', bool,
        'Cehck Cr50 Board ID Value is ffffffff or 00007f80.',
        default=True),
  ]

  def CheckCr50BoardIDValue(self):
    self.ui.SetState(_('Starting Cr50 Board ID Value Check...'))
    time.sleep(1)

    actual_board_id = os.popen("gsctool -a -i | cut -d':' -f4").read().strip()
    session.console.info('DUT Actual Board ID Value is %s', actual_board_id)
    board_id_spec_list = ['ffffffff', '00007f80']

    if actual_board_id in board_id_spec_list:
      session.console.info(
        'Checked Actual Board ID Value match spec list. PASSED!')
      self.ui.SetState(
        _('Checked Actual Board ID Value match spec list. PASSED!'))
    else:
      msg = (
        'Checked Actual Board ID is %s diffrent spec list %s.', actual_board_id,
        board_id_spec_list)
      self.fail(msg)

  def setUp(self):
    self.dut = device_utils.CreateDUTInterface()
    self.ui.ToggleTemplateClass('font-large', True)
    dut_shell = functools.partial(gooftool_common.Shell, sys_interface=self.dut)
    #self.gsctool = gsctool.GSCTool(shell=dut_shell)
    self.gsctool = gsctool.GSCTool()
    #self.goofy_rpc = state.get_instance()

  def runTest(self):
    self.ui.SetState(_('Starting Cr50 Board ID Value Check...'))

    if self.args.check_cr50_board_id:
      self.CheckCr50BoardIDValue()
