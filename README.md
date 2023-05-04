# Ledger Tesseract training application

Fork of the boilerplate app used to train the tesseract model for OCR on Nano S Plus and Nano X devices screens.

## Quick start guide

```shell
#Install tesseract
sudo apt install tesseract-ocr

# Pull app-builder docker image and build app for Nano X (same screens as Nano S Plus)
sudo docker pull ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
sudo docker run --rm -ti --user "$(id -u):$(id -g)" --privileged -v "$(realpath .):/app" ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest bash -c "BOLOS_SDK=/opt/nanox-secure-sdk make"

# Execute the following make target that performs the following actions : 
#     * Prepare language data for tesseract (unichar sets and other training source data) 
#     * Get latest 'best trained' english model
#     * Generate pre-processed training snapshots and then groundtruth data (single line text images + detected text)
#       based on the snapshots.
make prepare-data
```

Now comes the painful step.

For every text line `.tif` image in the ground truth directory (`data/nanox-font-ocr-ground-truth`) you need to **check** the detected text and **manually fix** any error that the untrained Tesseract model has made in the associated `.gt.txt` file.

For instance, take this text line image (let's say it's called `data/nanox-font-ocr-ground-truth/00006_processed-002.exp0.tif`)

![example ground truth image](example.png)

You have to fix every error in the ground truth text file (that would be `data/nanox-font-ocr-ground-truth/00006_processed-002.exp0.gt.txt`)

So turn this : **ECwZarBglaKjR]¥s6G** into the correct string displayed which in this case is **ECwZarBglaKjRJYs6G**

Once you have done this for all ground truth images, you can train Tesseract by running :

```shell
# Run training
make train-nanox-ocr
```
