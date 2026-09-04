# Copyright 2024 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Set attested_device_id

Description
-----------
Set attested_device_id to device data.

Test Procedure
--------------
1. This test does not require operator interaction.
2. Read serial_number from device data and set it to attested_device_id.

Dependency
----------

Examples
--------
Minimum runnable example::

  {
    "pytest_name": "set_attested_device_id"
  }
"""

from cros.factory.test import test_case
from cros.factory.test import device_data
from cros.factory.utils.arg_utils import Arg


class SetAttestedDeviceIDTest(test_case.TestCase):
  ARGS = [
      Arg('serial_number', str,
          'Valid choice are "serial_number" and "mlb_serial_number".',
          default=device_data.NAME_SERIAL_NUMBER),
  ]

  def runTest(self):
    self.assertIn(self.args.serial_number,
                  [device_data.NAME_SERIAL_NUMBER,
                   device_data.NAME_MLB_SERIAL_NUMBER],
                  'The test argument "serial_number": '
                  f'"{self.args.serial_number}" is not a valid identifier.')
    serial_number = device_data.GetSerialNumber(self.args.serial_number)
    new_device_data = {'vpd.ro.attested_device_id': serial_number}
    device_data.UpdateDeviceData(new_device_data)
