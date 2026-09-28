# Vanguard Restart Without Reboot

A tiny Windows batch script that attempts to restart Riot Vanguard after you manually choose **Exit Vanguard**, without rebooting Windows.

## What it does

The script:

1. Requests Administrator privileges.
2. Starts the Vanguard kernel driver service, `vgk`, if it is not already running.
3. Starts the Vanguard user-mode service, `vgc`, if it is not already running.
4. Verifies that both services reach the `RUNNING` state.

On some Windows/Vanguard configurations, this is enough to restore Vanguard after exiting it from the system tray, avoiding a reboot.

## Usage

1. Download `Start_Vanguard.bat`.
2. Double-click it.
3. Accept the Windows UAC prompt.
4. Wait for both `vgk` and `vgc` to report `RUNNING`.
5. Launch Riot Client / League of Legends / VALORANT as usual.

## Manual equivalent

From an elevated Command Prompt or PowerShell:

```powershell
sc.exe start vgk
sc.exe start vgc
```

> In PowerShell, use `sc.exe`, not `sc`. PowerShell aliases `sc` to `Set-Content`.

## Why this can work

Riot Vanguard uses both `vgk`, a kernel-mode driver, and `vgc`, a Windows user-mode service. If `vgk` can be hot-loaded successfully in the current Windows session, `vgc` can then be started on top of it.

## Limitations

This is an **unofficial workaround** and is not guaranteed to work on every Riot Vanguard or Windows version. Riot may change Vanguard behavior at any time. Some systems may still require a reboot, especially after installation, updates, driver changes, or security-policy changes.

This script does **not** bypass, disable, patch, or modify Vanguard. It only asks Windows Service Control Manager to start the already-installed `vgk` and `vgc` services.

## Troubleshooting

```powershell
sc.exe query vgk
sc.exe query vgc
```

A healthy state is:

```text
STATE : 4  RUNNING
```

If `vgk` fails to start, a reboot may still be required.

## Disclaimer

This project is not affiliated with or endorsed by Riot Games. Riot Games, Vanguard, League of Legends, and VALORANT are trademarks or registered trademarks of Riot Games, Inc.

Use at your own risk.

## License

MIT
