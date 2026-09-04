# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Check the registration code

Description
-----------
This test checks that the registration code in the rw vpd.
- Check the registration code type
UNIQUE_CODE, GROUP_CODE, ONE_TIME_CODE, LEGACY

- Check the registration code device

Test Procedure
--------------
This is an automatic test that doesn't need any user interaction

Dependency
----------
- cros_config
- vpd
"""
import logging

from cros.factory.test import test_case
from cros.factory.test.rules import registration_codes
from cros.factory.external.chromeos_cli import vpd
from cros.factory.device import device_utils

UNIQUE = 'ubind_attribute'
GROUP = 'gbind_attribute'

class CheckRegistrationCodeTest(test_case.TestCase):
  """A factory test for reg code"""
  def setUp(self):
    self.dut = device_utils.CreateDUTInterface()
    self._vpd = vpd.VPDTool()
    self.rw_vpd = self._vpd.GetAllData(
        partition=vpd.VPD_READWRITE_PARTITION_NAME)
    self.reg_code_list = [self.rw_vpd[UNIQUE], self.rw_vpd[GROUP]]
    self.device_name = self.dut.CheckOutput(['cros_config', '/', 'name'])

  def runTest(self):
    for reg_code in self.reg_code_list:
      reg_code_object = registration_codes.RegistrationCode(reg_code)
      err_msg = 'In code %r, unexpected type %r' % (
          reg_code, reg_code_object.type)
      self.assertNotEqual(
          reg_code_object.type,
          registration_codes.RegistrationCode.Type.ONE_TIME_CODE,
          err_msg)
      self.assertNotEqual(
          reg_code_object.type,
          registration_codes.RegistrationCode.Type.LEGACY,
          err_msg)
      self.assertIsNotNone(reg_code_object.device)
      self.assertEqual(reg_code_object.device, self.device_name)
      logging.info('reg_code %r check passed, type: %r, device: %r',
                   reg_code, reg_code_object.type, reg_code_object.device)
