# FontKeep Developer Guide

This documentation covers the setup, development workflow, and contribution guidelines for the FontKeep Flutter application.

## 🛠️ Environment Setup

1.  **Prerequisites:**
    * [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
    * **Windows:** Visual Studio with C++ workload & [WiX Toolset](https://wixtoolset.org/) (for MSI building).
    * **Linux:** `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `liblzma-dev`, `libsecret-1-dev`, `libjsoncpp-dev`, `libfuse2`, `rpm`.
    * **macOS:** Xcode & `npm install -g appdmg`.

2.  **Installation:**
    ```bash
    cd fontkeep_app
    flutter pub get
    dart pub global activate fastforge
    ```

3.  **Run Locally:**
    ```bash
    flutter run -d windows  # or linux/macos
    ```

## 📐 Contribution Workflow

We follow a strict branching and commit strategy to automate our release pipelines.

### 1. Branching Strategy
* **Version Branches (`X.X.X`):** Created ONLY by Admins (e.g., `1.0.0`, `1.0.1`). Represents a specific release state.
* **Feature/Dev Branches:** Created by contributors. Must follow these naming patterns:
    * `feature/<name>` - New capabilities.
    * `bugfix/<name>` - Fixes for existing issues.
    * `optimization/<name>` - Performance improvements.
    * `security/<name>` - Vulnerability fixes.
    * `infra/<name>` - CI/CD or repo maintenance.

### 2. Commit Guidelines

We use an automated release pipeline. To ensure your changes appear correctly in the release notes, please follow this format:

1.  **Subject Line:** Must start with a category prefix (`feature:`, `bugfix:`, etc.).
2.  **Description (Optional):** You can add a detailed description in the commit body (leave a blank line after the subject). This will be included in the release notes automatically.

Your commit messages determine the Release Notes. You **must** follow this format:

`type: <description>`

| Type | Description | Included in Release Notes? |
| :--- | :--- | :---: |
| **feature** | New features or major changes | ✅ Yes |
| **optimization** | Performance or efficiency improvements | ✅ Yes |
| **bugfix** | Fixes for bugs or crashes | ✅ Yes |
| **security** | Security patches or vulnerability fixes | ✅ Yes |
| **infra** | CI/CD, build scripts, or project config | ❌ No |

**Example Commit:**
```text
feature: Added new font preview engine
```

The new engine uses Skia for faster rendering and supports variable fonts.
It also reduces memory usage by 40% when loading large font families.

Note: Merge commits (e.g., "Merge pull request #123") are automatically ignored by our pipeline.

### 3. Making a Pull Request (PR)
1.  Push your branch (`feature/my-cool-feature`).
2.  Open a PR against `develop` (or the targeted version branch).
3.  Fill out the **PR Template** completely.
4.  Wait for review and CI checks to pass.
5.  **Admins:** Squash and merge is recommended to keep history clean.

## 📦 Building & Releases (Admins Only)

Releases are automated via GitHub Actions.

1.  **Pre-release:** Push to `develop`. This creates a pre-release tag (e.g., `v0.0.12`).
2.  **Stable Release:**
    * Create a branch named `v1.0.0` (or target version).
    * Push to GitHub.
    * The pipeline will build installers, sign them, generate changelogs, scan with VirusTotal, and publish a Draft Release.

## 🧪 Testing
Run unit and widget tests before pushing:
```bash
flutter test
```