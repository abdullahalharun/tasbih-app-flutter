# Removing Firebase Secrets from Git History

## ⚠️ CRITICAL: Do this IMMEDIATELY

Your Firebase secrets have been exposed in a public repository. Follow these steps:

## Step 1: Rotate Your Firebase API Keys (DO THIS FIRST!)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `tasbih-app-flutter`
3. Go to Project Settings → General
4. For each platform (Web, iOS, Android):
   - Delete the current app
   - Create a new app with the same bundle ID
   - Download new configuration files
5. Update your local files with the new keys

## Step 2: Remove Files from Git History

### Method 1: Using git-filter-repo (Recommended)

```bash
# Install git-filter-repo
pip3 install git-filter-repo

# Navigate to your repo
cd /Users/harunrrashid/projects/flutter-projects/tasbih-app-flutter

# Remove sensitive files from all history
git filter-repo --invert-paths \
    --path android/app/google-services.json \
    --path ios/Runner/GoogleService-Info.plist \
    --path macos/Runner/GoogleService-Info.plist \
    --path lib/firebase_options.dart \
    --force
```

### Method 2: Using BFG Repo-Cleaner

```bash
# Install BFG (using Homebrew on macOS)
brew install bfg

# Clone a fresh copy
cd /tmp
git clone --mirror https://github.com/abdullahalharun/tasbih-app-flutter.git

# Remove files
bfg --delete-files google-services.json tasbih-app-flutter.git
bfg --delete-files GoogleService-Info.plist tasbih-app-flutter.git
bfg --delete-files firebase_options.dart tasbih-app-flutter.git

# Clean up
cd tasbih-app-flutter.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push
git push --force
```

## Step 3: Force Push to GitHub

After cleaning history:

```bash
# Add the remote back (if using git-filter-repo)
git remote add origin https://github.com/abdullahalharun/tasbih-app-flutter.git

# Force push all branches and tags
git push origin --force --all
git push origin --force --tags
```

## Step 4: Verify and Add New Files

```bash
# Verify files are gitignored
git status

# The following should NOT appear:
# - google-services.json
# - GoogleService-Info.plist  
# - firebase_options.dart

# Add the new .gitignore and template files
git add .gitignore
git add lib/firebase_options.dart.template
git add FIREBASE_SETUP.md
git add SECURITY.md
git commit -m "chore: add Firebase setup instructions and remove secrets from tracking"
git push origin develop
```

## Step 5: Notify Collaborators

If others have cloned the repo:

```bash
# They need to re-clone
git clone https://github.com/abdullahalharun/tasbih-app-flutter.git
```

## Step 6: Enable Additional Security

1. **Enable Firebase App Check** in Firebase Console
2. **Add API key restrictions** in Google Cloud Console:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to APIs & Services → Credentials
   - Restrict each API key to specific APIs and domains

## Important Notes

- ⚠️ Force pushing will rewrite history - notify all collaborators
- ⚠️ Anyone who forked your repo will still have the old keys
- ⚠️ The keys might be cached in GitHub's CDN for a while
- ✅ That's why rotating the keys (Step 1) is CRITICAL

## Alternative: Make Repository Private

If this is a personal project, consider making the repository private:
1. Go to GitHub repository settings
2. Scroll to "Danger Zone"
3. Click "Change visibility" → "Make private"
