## ⬇️ How to GitHub ⬆️

If you're new to git, GitHub, or **if you've never contributed to a git repository that you didn't originally create**, you may be wondering how to actually get your changes into the project. It may be a little different than what you're used to.

A little background that you may or may not need:

- **git** is the name of the open-source software that is used to track changes to a project. You also use git to sync your local copy of the files in a project with a copy that is hosted online. It is a command line tool with no graphical interface.
- A **git client** is a piece of software that "wraps around" git and provides it with a graphical interface. Not everyone uses one, but they're popular even among command line experts. There are many git clients, but they are all simply *interfaces* for git, so they all do the same thing. Most clients come with a copy of git, so you won't need to download or install git separately.
- Lastly, **GitHub** is the most popular online host for git-tracked projects, but there are others. Since this project is hosted on GitHub, these instructions will be GitHub-specific, but git and GitHub are not the same thing.

Now with that out of the way, **here's the step-by-step** (feel free to skip some of these if you've already done them for another project):

1. **[Sign up](https://github.com/signup) for a GitHub account.**
   If you have a Microsoft account, GitHub might ask if you want to sign in using that. It's up to you!

2. **Fork this project into your account**
   You don't have permissions to upload changes directly to this project. So, when you save ("commit") your changes locally and upload ("push") them to GitHub, you'll need to upload them to a copy ("fork") that you *do* have permissions to change.

   The way you create this copy is by scrolling to the very top of this project's page and clicking the rectangular "Fork" button (between "Watch" and "Starred").

   You now have a copy of the project in your account. Only you can make changes to this copy, so it won't automatically be updated with anyone else's changes. Don't worry, this isn't a problem. The project's maintainers will "pull" your changes into the original copy in a later step.

3. **Set up a git client (or standalone git) on your computer.**

   - [Fork](https://git-fork.com/) (recommended)
   - [SourceTree](https://www.sourcetreeapp.com/)
   - [GitKraken](https://www.gitkraken.com/)
   - [git (standalone)](https://git-scm.com/downloads)

4. **Sign into your GitHub account in your git client.**
   The instructions on this differ slightly between clients:

   - using Fork: go to `File > Accounts > [+] > GitHub`
   - [using SourceTree](https://confluence.atlassian.com/get-started-with-sourcetree/connect-your-bitbucket-or-github-account-847359096.html)
   - [using GitKraken](https://support.gitkraken.com/integrations/github/)
   - [using git (standalone)](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git)

5. **Clone your forked copy onto your computer**
   Go to the page for *your* forked copy (<u>github.com/[your-name]/a-little-game-called-mario/</u>) and click the green "Code" dropdown button.

   You'll see a URL that you can copy, which is the same at the page you're on but with ".git" at the end. Copy this full URL.

   Now you're ready to download ("Clone") your fork. 

   - using Fork: go to `File > Clone`
   - [using SourceTree](https://confluence.atlassian.com/get-started-with-sourcetree/connect-your-bitbucket-or-github-account-847359096.html)
   - [using GitKraken](https://support.gitkraken.com/integrations/github/)
   - [using standlalone git](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository)

   You now have a *local copy* of your *forked copy* of the *original repository* (fwew!).

6. **Create a reference to the original project (for later)**
   Once your changes are finished and submitted, you'll need to re-sync your local copy with the original in order to make future changes. We'll do that later, but first we need to add a reference to the original remote copy in your git client. This is called "adding a remote."

   For this, you'll need the ".git" URL of the original project, which is: https://github.com/a-little-org-called-mario/a-little-game-called-mario.git

   - using Fork:
     1. In the left toolbar, right-click "Remotes > Add New Remote..."
     2. Change `Remote:` from "origin" to "upstream" (your forked copy is already called "origin")
     3. Enter the URL in `Repository Url:`
     4. Click the "Add New Remote" button.

   You now have two "remotes" referenced in your local repository, your fork ("origin"), and the original ("upstream"). You won't be using the upstream remote you just added until the very end of this process.

   🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 

   *At this point, you've done all the setup you'll need to do!*

   *Each time you want to make and submit a new change, start at the next step below.*

   🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 

7. **Okay, the fun bit. Make your changes!**
   Be careful to limit the amount of changes you make. You can change multiple files, but try to keep your changes limited to one "thing" at a time: one feature, one bugfix, one art, etc.

   Remember that your local copy isn't synced with the original copy, so the more things you change before submitting, the more likely there will be conflicts with other people's changes. This is true in general, but especially for this project.

8. **Commit your changes to your local repository.**
   Once you're satisfied with your changes, use your git client to save ("commit") them to your local repository. A commit is essentially a manual checkpoint for your project. Editing and saving files to disk will not commit them to your local repository, you need to do that step separately.

   *Again, each git client works slightly differently, so refer to documentation (or Google).*The main thing to consider at this step is your **Commit Message**. This is a short sentence which describes, as simply as possible, what your changes do. Take a look at commit messages by others to get an idea for what goes in them.

   You cannot edit this message later, so be careful with how many typos you include.

   **ADVANCED:** If your change fixes a known bug or follows up on a conversation or feature request, you can reference the GitHub Issue related to that in your message, by simply including the number of the issue with a # in front of it (eg #74, #208). GitHub recognizes it like a hashtag, and will turn it into a link to that issue *and* create a link back to your commit on that issue's page. This is optional, but really helps others identify when known issues have been addressed.

9. **Push your changes to your forked copy**
   Once your changes have been committed, you can upload ("push") your commit to your forked copy on GitHub. Refer to your git client's documentation, but it's usually a big button that says "Push" 😆. Make sure that you're pushing to "origin/main."

   *So great, now your changes are online, but they're not in the project yet...*

10. **Create a pull request**
    Now that your changes are online, you're ready to submit them to the project. The way you do this is by creating a "pull request." You are asking the maintainers of the project to review and pull in your changes.

    1. In your browser, go to <u>*your forked copy*</u> on GitHub and click the "Pull requests" tab at the top of the page.
    2. You'll see an interface which compares your copy to the original copy, showing the commits that exist in your copy which don't exist in the original (aka, your changes)
    3. Press "Create Pull Request" and optionally enter a message further explaining your changes. If your commit message(s) was enough, you don't have to enter anything more (This is another opportunity to reference a GitHub Issue if you didn't do so in your commit message).

    Now, you wait... The project maintainers will manually review your change and if it doesn't break anything or violate any of the rules, they will approve it.

    *So, what next?*

11. **Keep going?**
    You can continue to work in your local copy of the project, push changes to your forked remote, and create new pull requests. If you want to pull new changes from others into your copy, you can do that by pulling from "upstream/main" in your git client (by default, your git client will pull from "origin/main" but since only you can make changes to that copy, there's never anything to pull).

12. **Rebase your local copy**
    Assuming your request was accepted, 🥳congratulations🥳, your changes are now in the project, and live in the game! Do a dance if you like.

    Of course, there's a chance your pull request was rejected ("closed"), either because it broke the game, violated a rule, or simply duplicated work that someone else did first. Don't fret, there's plenty more changes to make!

    *Either way*, now it's time to re-sync your local copy with the original copy. Even though the files in your local copy and the original copy might now be identical, your repository history is likely to be different, for any number of reasons. If this is confusing, don't worry, just follow these steps every time to reset things.

    - using Fork:
      1. In the left toolbar, click the arrow next to `upstream` to reveal that remote's "branches," including `main`.
      2. Right click on `main` and select `Rebase main on "upstream/main.` This will erase your local history and replace it with the history from the original copy of the repository.

    You may now notice that your remote fork need to be synced as well...

13. **"Force push" to your remote fork**
    Your local copy ("main") is now in sync with the original copy ("upstream/main"), but your remote fork ("origin/main") is still out of sync! The last step before you're ready to start this process again is to again push your local changes to your remote fork, but since you've rebased your local copy, you need to "force" the push.

    - using Fork:
      1. Press `Push` in the top toolbar
      2. Make sure that you have selected "origin" as your remote.
      3. Select the "force push" checkbox.
      4. Press the "Push" button.

    Okay! That should be it. You're local copy and remote fork are now in-sync with the original copy, which (hopefully) included your recent changes. You can now start making new changes!