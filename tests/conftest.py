from ragger.conftest import configuration

###########################
### CONFIGURATION START ###
###########################

# You can configure optional parameters by overriding the value of ragger.configuration.OPTIONAL_CONFIGURATION
# Please refer to ragger/conftest/configuration.py for their descriptions and accepted values

#########################
### CONFIGURATION END ###
#########################

def pytest_addoption(parser):
    parser.addoption("--processed-snapshots-dir", action="store", default="data/nano-font-ocr-ground-truth", help="Path to processed training screenshots output directory.")

# Pull all features from the base ragger conftest using the overridden configuration
pytest_plugins = ("ragger.conftest.base_conftest", )
