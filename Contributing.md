# Contributing Guidelines
Thanks for your interest in contributing to this project! To keep the codebase healthy and collaboration smooth, please follow the guidelines below when making changes.

---

## 🧭 Workflow Overview
All contributions — whether bug fixes, new features, documentation updates, or refactoring — must follow a branch + pull request workflow.

### Do not push directly to `main`
The main branch represents stable, reviewed, production‑ready code. Direct commits bypass review and make it harder to maintain project quality.

---

## 🌱 Creating a Branch
Before you start working:

```bash
git checkout main
git pull
```
Create a new branch for your work:

```bash
git checkout -b feature/my-new-feature
```
Use a descriptive name that reflects the purpose of the change.
Branches should be small and focused — if you find yourself doing multiple unrelated things, split them into separate branches.

---

## 📝 Commit Practices
Small, frequent commits make your pull request easier to review and help future contributors understand the history of your changes.

Good commit habits:
- Commit locally and often.
- Each commit should represent a logical step.
- Write commit messages that explain what changed and why.
- Avoid giant “misc fixes” commits unless absolutely necessary.
- This helps maintain a clean project history and makes debugging far easier.

Please follow the conventional commits guidelines in your commit titles https://www.conventionalcommits.org/en/v1.0.0/

## 🔀 Opening a Pull Request
When your branch is ready:

```bash
git push -u origin feature/my-new-feature
```
Then open a Pull Request (PR) targeting `main`.

Your PR should:
- Explain the purpose of the change.
- Mention any related issues.
- Describe testing steps or expected behavior.
- Stay focused — avoid mixing unrelated changes.

All PRs are reviewed before merging. Feedback is normal and part of the process.

## 🧪 Testing & Verification
Before submitting a PR:
- Ensure your changes run cleanly.
- Verify that you didn’t break existing functionality.

Update documentation when needed.

## 🤝 Thank You
Every contribution — big or small — helps improve the project. Thanks for taking the time to follow these guidelines and keep the codebase healthy.
