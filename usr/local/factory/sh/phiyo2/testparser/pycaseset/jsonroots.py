from testparser.jsonparser import jcommand, jconfig, jinfogenerator, jportsettings, jtestcase, jsettings
from common import lazyproperty


class JsonRoots(object):
    @lazyproperty
    def command(self):
        return jcommand.JsonCommandRoot.instance()

    # @lazyproperty
    # def command_format(self):
    #     return jcommandformat.JsonCommandFormatRoot.instance()

    @lazyproperty
    def config(self):
        return jconfig.JsonConfigRoot.instance()

    @lazyproperty
    def info_generator(self):
        return jinfogenerator.JsonInfoGeneratorConfigRoot.instance()

    @lazyproperty
    def port_settings(self):
        return jportsettings.JsonPortSettingsRoot.instance()

    @lazyproperty
    def test_case(self):
        return jtestcase.JsonTestCaseRoot.instance()

    @property
    def settings(self):
        return jsettings.JsonSettingsRoot.instance()
