# 2Baked

<p align="center">
  <img src="web/icons/branding/2baked-app-icon-master-v2.png" alt="2Baked red-eyed weed leaf mascot" width="180">
</p>

2Baked is a responsive Flutter Web PWA built for iPhone home-screen installation and desktop browsers. It combines a two-stage heat/cool dab timer with custom presets, optional spoken facts, gear profiles, favorites, and private local session history.

## Included

- Accurate deadline-based heating and cooldown stages
- Ember-red clockwise heat ring and ice-blue reverse cooldown ring
- Four starter presets plus saved custom presets
- Pause, resume, reset, favorites, and a centered ready alert
- Screen wake lock enabled by default during active timers, with resume reacquisition
- Optional text-to-speech timer calls and shuffled facts
- 50 evidence-conscious facts and safety reminders
- Gear profiles for glass rigs, quartz bangers, e-rigs, and nectar collectors
- Local-only display name, preferences, stats, and session history
- Responsive mobile navigation and desktop sidebar
- Installable PWA metadata and original 2Baked icon set
- Original red-eyed weed-leaf mascot used in the app header and full PWA icon set

## Run locally

```powershell
& 'C:\Users\Little Regulus\flutter-sdk-stable\bin\flutter.bat' run -d chrome
```

The browser may require the first timer tap before speech is allowed. Safari/iOS uses the voices available on the device.

## Verify and build

```powershell
& 'C:\Users\Little Regulus\flutter-sdk-stable\bin\flutter.bat' analyze
& 'C:\Users\Little Regulus\flutter-sdk-stable\bin\flutter.bat' test
& 'C:\Users\Little Regulus\flutter-sdk-stable\bin\flutter.bat' build web --release --no-web-resources-cdn
```

For a GitHub Pages project site, build with the repository name as the base path:

```powershell
& 'C:\Users\Little Regulus\flutter-sdk-stable\bin\flutter.bat' build web --release --no-web-resources-cdn --base-href '/YOUR_REPOSITORY_NAME/'
```

The included GitHub Actions workflow calculates that base path automatically. In the repository settings, set **Pages → Source** to **GitHub Actions**, then push the project to the `main` branch.

## Install on iPhone

Open the deployed site in Safari, tap **Share**, choose **Add to Home Screen**, then launch 2Baked from its icon. Profile data is stored only in that Safari installation; clearing site data or removing the PWA can remove it.

## Safety note

2Baked is a timing and record-keeping tool, not medical or dosing advice. It is intended for adults where legal. Hot equipment can cause burns or fire, and no one should drive or operate machinery while impaired.
