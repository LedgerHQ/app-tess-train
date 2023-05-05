from pathlib import Path
from ragger.navigator import NavInsID
from process_snapshots import process_snapshots

ROOT_SCREENSHOT_PATH = Path(__file__).parent.resolve()

def test_get_training_snapshots(request, firmware, navigator, test_name):
    # In your test function, use the request fixture to access the value of the option
    processed_path = request.config.getoption("--processed-snapshots-dir")

    # Navigate in the main menu
    devices = ["nanox","nanosp"]
    if firmware.device in devices:
        text = "Quit"
        navigate_instruction = NavInsID.RIGHT_CLICK
        validate_instruction = [NavInsID.RIGHT_CLICK]
    else:
        # Stax training not supported yet. Nano S training not necessary so it will never be supported either.
        exit
    
    navigator.navigate_until_text_and_compare(navigate_instruction,
                                            validate_instruction,
                                            text,
                                            ROOT_SCREENSHOT_PATH,
                                            test_name,
                                            screen_change_before_first_instruction=False,
                                            screen_change_after_last_instruction=False)
    
    # Process generated snapshots for tesseract training
    snapshots_path = ROOT_SCREENSHOT_PATH / "snapshots-tmp" / firmware.device / test_name
    process_snapshots(snapshots_path, processed_path)
