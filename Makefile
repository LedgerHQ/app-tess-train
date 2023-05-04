# ****************************************************************************
#    Ledger App Boilerplate
#    (c) 2020 Ledger SAS.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# ****************************************************************************

ifeq ($(BOLOS_SDK),)

$(info Environment variable BOLOS_SDK is not set)

SHELL := /bin/bash
.ONESHELL:

.PHONY: requirements
requirements:
	@echo "Create python virtual and install requirements" 
	python3 -m venv tessvenv
	source tessvenv/bin/activate
	pip3 install --upgrade pip
	pip3 install --extra-index-url https://test.pypi.org/simple/ -r tests/requirements.txt

.PHONY: snapshots
snapshots: requirements
	source tessvenv/bin/activate
	@echo "Launching ragger test to generate training snapshots"
	python3 -m pytest --device nanox -k "test_get_snapshots" --golden_run

.PHONY: ground-truth
ground-truth: snapshots
	source tessvenv/bin/activate
	@echo "Launching split.sh script to generate ground truth..."
	./split.sh

.PHONY: download-eng-model
download-eng-model:
	mkdir -p ./data/model
	wget -O ./data/model/eng.traineddata https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata

.PHONY: prepare data
prepare-data: download-eng-model ground-truth
	$(MAKE) -C tesstrain tesseract-langdata DATA_DIR=../data

.PHONY: train-nanox-ocr
train-nanox-ocr:
	$(MAKE) -C tesstrain training DATA_DIR=../data MODEL_NAME=nanox-font-ocr START_MODEL=eng TESSDATA=data/model MAX_ITERATIONS=5000

else

include $(BOLOS_SDK)/Makefile.defines

APPNAME      = "Boilerplate"
APPVERSION_M = 1
APPVERSION_N = 0
APPVERSION_P = 1
APPVERSION   = "$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)"

# - <VARIANT_PARAM> is the name of the parameter which should be set
#   to specify the variant that should be build.
# - <VARIANT_VALUES> a list of variant that can be build using this app code.
#   * It must at least contains one value.
#   * Values can be the app ticker or anything else but should be unique.
VARIANT_PARAM = COIN
VARIANT_VALUES = BOL

APP_LOAD_PARAMS += --curve secp256k1
APP_LOAD_PARAMS += --path "44'/1'"   # purpose=coin(44) / coin_type=Testnet(1)

ifeq ($(TARGET_NAME),TARGET_NANOS)
    ICONNAME=icons/nanos_app_boilerplate.gif
else ifeq ($(TARGET_NAME),TARGET_STAX)
    ICONNAME=icons/stax_app_boilerplate_32px.gif
else
    ICONNAME=icons/nanox_app_boilerplate.gif
endif

ENABLE_BLUETOOTH = 1

# Enabling DEBUG flag will enable PRINTF and disable optimizations
DEBUG ?= 0

ENABLE_NBGL_QRCODE   = 1
ENABLE_NBGL_KEYBOARD = 0
ENABLE_NBGL_KEYPAD   = 0

APP_SOURCE_PATH += src

include $(BOLOS_SDK)/Makefile.standard_app

endif


