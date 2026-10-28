
# Auto-Editor Premiere Pro XML — Windows Audio Silence Removal

A Windows utility that adds a right-click context-menu option to MP3 and WAV files to generate Adobe Premiere Pro XML timelines using Auto-Editor.

The workflow uses a Windows batch script to run the Auto-Editor command-line executable with configurable silence-detection, audio-padding, smoothing, and export settings.

**This project is a Windows integration wrapper for Auto-Editor, not a replacement for the original Auto-Editor software.**

## Credits & Original Project

This project uses the Auto-Editor command-line tool, originally created by [Wyatt Blue](https://github.com/WyattBlue).

- **Original project:** [Auto-Editor](https://github.com/WyattBlue/auto-editor)
- **Original author:** [Wyatt Blue](https://github.com/WyattBlue)
- **Purpose of this project:** Add a convenient Windows context-menu workflow for generating Premiere Pro XML timelines from audio files.

The Windows batch script and registry files provide the integration workflow and configurable defaults around the Auto-Editor CLI.

All credit for the original Auto-Editor software belongs to its original author and contributors.

Please review the original project's license and comply with its attribution, redistribution, and notice requirements when distributing the bundled executable.

## Features

- **Windows Context Menu:** Right-click an MP3 or WAV file to start processing.
- **Adobe Premiere Pro XML Export:** Generate a Premiere Pro XML timeline from an audio file.
- **Automatic Silence Removal:** Detect inactive audio sections and configure them to be cut.
- **Configurable Audio Threshold:** Adjust the loudness threshold used for silence detection.
- **Audio Stream Selection:** Choose which audio stream to analyze.
- **Audio Channel Selection:** Configure the audio channel used for analysis.
- **Adjustable Audio Margins:** Preserve audio before and after active sections.
- **Smoothing Controls:** Configure minimum cut and clip durations.
- **Configurable Output Naming:** Add a suffix to generated XML filenames.
- **Input Validation:** Check that an input file exists and has a supported extension.
- **Error Handling:** Display an error when Auto-Editor fails or the expected XML output is missing.
- **Automatic Window Closing:** Configure the delay before the command window closes after successful processing.
- **Registry Integration:** Separate registry files add or remove the Windows context-menu entries.

## Requirements

- Windows.
- The bundled `auto-editor.exe` executable.
- An MP3 or WAV input file.
- Adobe Premiere Pro or another compatible workflow for using the generated XML.

The utility is designed to generate XML files. The supplied project does not automatically open Premiere Pro or import the generated XML into an existing project.

## Installation

The supplied registry files use the fixed installation path:

`C:\Auto_Editor`

### Step 1: Extract the Project

Extract the ZIP archive.

The supplied archive contains this directory structure:

```text
Auto_Editor/
├── Add Auto_Editor.reg
├── Remove Auto_Editor.reg
└── C/
    └── Auto_Editor/
        ├── auto-editor.exe
        └── handler.bat
```

### Step 2: Copy the Application Files

Create the following directory:

`C:\Auto_Editor`

Copy these two files into it:

- `auto-editor.exe`
- `handler.bat`

The resulting paths should be:

```text
C:\Auto_Editor\auto-editor.exe
C:\Auto_Editor\handler.bat
```

**Important:** The registry entries point to `C:\Auto_Editor\handler.bat`. If you install the files elsewhere, you must update the paths in `Add Auto_Editor.reg` before importing it.

### Step 3: Add the Context Menu

1. Locate `Add Auto_Editor.reg`.
2. Double-click the file.
3. Review the registry changes.
4. Confirm the import when Windows prompts you.

The registry file adds a context-menu option named **Generate Premiere Pro XML** for MP3 and WAV files.

Registry modifications affect your Windows configuration. Review the `.reg` file before importing it.

### Step 4: Start Using the Utility

1. Open File Explorer.
2. Locate an MP3 or WAV file.
3. Right-click the file.
4. Select **Generate Premiere Pro XML**.

The batch script starts Auto-Editor with the configured options and generates an XML file alongside the input audio file.

## How to Use

### Generate a Premiere Pro XML Timeline

1. Right-click an MP3 or WAV file.
2. Select **Generate Premiere Pro XML**.
3. Wait while Auto-Editor analyzes the audio and processes the edit.
4. Check the output file in the same directory as the source audio.

By default, an input file named:

`Podcast.mp3`

produces:

`Podcast_ALTERED.xml`

The output filename suffix is configurable.

### Import the XML into Premiere Pro

After generation:

1. Open Adobe Premiere Pro.
2. Open the project in which you want to use the edit.
3. Import the generated XML using Premiere Pro's supported project-import workflow.
4. Review the resulting timeline and media references.

Compatibility may depend on the Auto-Editor version, XML export behavior, and your Premiere Pro version.

## Configuration

Open `C:\Auto_Editor\handler.bat` in a text editor.

The configuration section appears near the top of the file.

Save your changes before running the utility again.

### General Settings

| Variable | Default | Description |
|---|---|---|
| `Auto_Close` | `1` | Number of seconds to wait before closing the command window after successful processing. Set to `0` to keep the window open until a key is pressed. |

### Silence Detection Settings

| Variable | Default | Description |
|---|---|---|
| `EDIT_METHOD` | `audio` | Selects the Auto-Editor editing method. |
| `SILENCE_THRESHOLD` | `6%` | Audio threshold used to distinguish active audio from quieter sections. |
| `AUDIO_STREAM` | `all` | Selects the audio stream to analyze. |
| `AUDIO_CHANNEL` | `all` | Selects the audio channel to analyze. |

A higher threshold generally makes silence removal more aggressive, while a lower threshold can preserve quieter speech.

The appropriate threshold depends on the recording, background noise, microphone level, and desired editing style.

### Audio Margins

| Variable | Default | Description |
|---|---|---|
| `MARGIN_BEFORE` | `0.2sec` | Audio retained before an active section. |
| `MARGIN_AFTER` | `0.2sec` | Audio retained after an active section. |

Margins help preserve the beginnings and endings of words rather than cutting too close to detected activity.

### Smoothing

| Variable | Default | Description |
|---|---|---|
| `MINCUT` | `0.2sec` | Minimum duration of a section that can be cut. |
| `MINCLIP` | `0.1sec` | Minimum duration of a section that can be kept. |

These values help control how short sections are treated during the edit.

### Active and Inactive Sections

| Variable | Default | Description |
|---|---|---|
| `WHEN_ACTIVE` | `nil` | Editing action applied to active sections. |
| `WHEN_INACTIVE` | `cut` | Editing action applied to inactive sections. |

The default configuration keeps active audio and cuts inactive sections.

### Export Settings

| Variable | Default | Description |
|---|---|---|
| `EXPORT_FORMAT` | `premiere` | Selects the Premiere Pro export format. |
| `OUTPUT_SUFFIX` | `_ALTERED` | Suffix appended to the output XML filename. |

For example, changing `OUTPUT_SUFFIX` to `_EDITED` changes the output name from `Podcast_ALTERED.xml` to `Podcast_EDITED.xml`.

## How It Works

### 1. Windows Registry Integration

`Add Auto_Editor.reg` registers a context-menu command for files with the `.mp3` and `.wav` extensions.

When the menu item is selected, Windows launches `handler.bat` and passes the selected file path as an argument.

### 2. Input Validation

The batch script checks that:

- An input file was provided.
- The file exists.
- The file extension is `.mp3` or `.wav`.
- `auto-editor.exe` exists in the expected directory.

If validation fails, the script displays an error and stops processing.

### 3. Command Construction

The batch script builds the Auto-Editor command from the configured values, including:

- Editing method and audio threshold.
- Audio stream and channel.
- Margins and smoothing.
- Active and inactive section actions.
- Export format and output filename.

### 4. Audio Processing

The script invokes the bundled Auto-Editor executable with the constructed command-line arguments.

Auto-Editor performs the audio analysis and generates the requested export.

### 5. Output Verification

After execution, the batch script checks the process exit status and verifies that the expected XML file exists.

If processing fails or the output is missing, an error message is displayed.

### 6. Registry Removal

`Remove Auto_Editor.reg` removes the context-menu entries registered by the installation file.

Removing the registry entries does not delete the application files in `C:\Auto_Editor`.

## Removing the Context Menu

To remove the context-menu integration:

1. Locate `Remove Auto_Editor.reg`.
2. Review the registry entries.
3. Double-click the file.
4. Confirm the registry import.

This removes the registered context-menu items for MP3 and WAV files.

You can then manually delete `C:\Auto_Editor` if you no longer need the application files.

## Troubleshooting

### The Context Menu Does Not Appear

- Confirm that `Add Auto_Editor.reg` was imported successfully.
- Check that the input file has an `.mp3` or `.wav` extension.
- Confirm that the registry command points to the correct `handler.bat` path.

### Auto-Editor Is Not Found

The script expects:

`C:\Auto_Editor\auto-editor.exe`

Make sure the executable is in the same directory as `handler.bat`.

### The XML File Is Not Generated

- Check that the input file exists and is accessible.
- Review the configured threshold and export settings.
- Check the displayed command and Auto-Editor error output.
- Confirm that the bundled executable supports the command-line options used by the script.

### Silence Removal Is Too Aggressive

Lower `SILENCE_THRESHOLD` to retain quieter speech and background audio.

You can also increase `MARGIN_BEFORE` and `MARGIN_AFTER` to preserve more audio around active sections.

### Too Much Silence Remains

Consider increasing `SILENCE_THRESHOLD` gradually and testing the result on a copy of the original recording.

Threshold changes can affect quiet speech, breaths, and background sounds, so review the generated timeline before using it in a final edit.

### The Command Window Closes Too Quickly

Set:

`set "Auto_Close=0"`

The window will remain open after successful processing until a key is pressed.

## Known Limitations

- The context-menu registration assumes the installation path `C:\Auto_Editor`.
- Only MP3 and WAV input files are accepted by the supplied batch script and registry entries.
- The workflow generates a Premiere Pro XML file; it does not automatically open or import the file into Premiere Pro.
- Silence detection depends on the source audio and configured threshold.
- The utility relies on the command-line options supported by the bundled Auto-Editor executable.
- The supplied project does not include an automated test suite or build system.

## Contributing

Bug reports, configuration improvements, and suggestions are welcome.

When reporting an issue, include:

- Your Windows version.
- The Auto-Editor executable version, if known.
- The input audio format.
- The configured threshold and margin values.
- The error output, if available.

## License and Attribution

This project integrates the Auto-Editor command-line tool.

Original project: [https://github.com/WyattBlue/auto-editor](https://github.com/WyattBlue/auto-editor)

Original author: [Wyatt Blue](https://github.com/WyattBlue)

The supplied archive does not include a separate license file for this Windows integration wrapper.

Before redistributing the bundled `auto-editor.exe`, review the original Auto-Editor repository's license and comply with its terms. Preserve required copyright notices and attribution.

Do not assume that the wrapper and the bundled executable necessarily have identical licensing terms.
