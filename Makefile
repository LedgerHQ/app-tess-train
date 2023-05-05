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

NANO_MODEL_NAME=nano-font-ocr
TRAINING_DATA_DIR=data
TRAINING_ITERATIONS=7000

SHELL := /bin/bash
.ONESHELL:

.PHONY: requirements snapshots ground-truth download-eng-model prepare-data copy-corrected-groundtruth-text train-nano-ocr
requirements:
	@echo "Create python virtual and install requirements" 
	python3 -m venv tessvenv
	source tessvenv/bin/activate
	pip3 install --upgrade pip
	pip3 install --extra-index-url https://test.pypi.org/simple/ -r tests/requirements.txt

snapshots: requirements
	@echo "Launching ragger test to generate training snapshots"
	source tessvenv/bin/activate
	python3 -m pytest --device nanox -k "test_get_snapshots" --golden_run --processed-snapshots-dir $(TRAINING_DATA_DIR)/$(NANO_MODEL_NAME)-ground-truth

ground-truth: snapshots
	@echo "Launching split.sh script to generate ground truth..."
	source tessvenv/bin/activate
	./split.sh $(TRAINING_DATA_DIR)/$(NANO_MODEL_NAME)-ground-truth/

download-eng-model:
	mkdir -p ./$(TRAINING_DATA_DIR)/model
	wget -O ./$(TRAINING_DATA_DIR)/model/eng.traineddata https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata

prepare-data: download-eng-model ground-truth
	$(MAKE) -C tesstrain tesseract-langdata DATA_DIR=../$(TRAINING_DATA_DIR)

copy-corrected-groundtruth-text:
	if [ ! -d "$(TRAINING_DATA_DIR)/$(NANO_MODEL_NAME)-ground-truth" ]; \
	then \
		$(MAKE) prepare-data ; \
	fi
	rm -f $(TRAINING_DATA_DIR)/$(NANO_MODEL_NAME)-ground-truth/*.gt.txt
	if [ ! -d "corrected-ground-truth" ]; \
	then \
		mkdir corrected-ground-truth && tar -xzf corrected-ground-truth-text.tar.gz -C corrected-ground-truth; \
	fi
	cp corrected-ground-truth/*.gt.txt $(TRAINING_DATA_DIR)/$(NANO_MODEL_NAME)-ground-truth

train-nano-ocr:
	$(MAKE) -C tesstrain training DATA_DIR=../$(TRAINING_DATA_DIR) MODEL_NAME=$(NANO_MODEL_NAME) START_MODEL=eng TESSDATA=../$(TRAINING_DATA_DIR)/model MAX_ITERATIONS=$(TRAINING_ITERATIONS)

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


