### Use `export` or not

Source: https://www.baeldung.com/linux/bash-variables-export

* Shell variable declaration without `export`
  * Like local/private variables
  * Loop counters, temporary variables
* Environment variable declaration with `export`
  * Like global/public variables
  * Child processes, bash scripts, build scripts/tools/jobs
  * In effect for all subsequent child/sub-processes of the shell
  * Copy of parent environment, parent variable can't be modified or returned

`source xyz.sh`, same as `. xyz.sh` executes the script within the same shell, so no child process, so current environment *is* modified (even without `export`)

### Files for Interactive Login and Non-Login Shell

Source: https://linuxize.com/post/bashrc-vs-bash-profile/ + various stackexchange questions

* interactive
  * reads and writes to a user’s terminal
  * Interactive Login Shell
    * login to the terminal remotely (via ssh) or locally
    * Order of files read on start
      1. `/etc/profile`
      2. `~/.bash_profile`
         * read only by Bash
         * commands that should run only once: customizing `$PATH` environment variable
         * Typically contains lines to source `.bashrc`: Each log in to the terminal reads/executes *both* files
         * can never be sourced again in child processes
      3. `~/.bash_login`
      4. `~/.profile` - read by all shells
  * Interactive Non-Login Shell
    * typing `bash` in the shell prompt, opening a new Gnome terminal tab
    * Order of files read on start
      1. `~/.bashrc`
         * commands that should run every time a new shell is launched: `alias`es, functions, custom prompts, history customizations
         * stuff that applies only to bash itself
         * incrementaly at every shell level
* non-interactive
  * not associated with a terminal, e.g. execute a script
* `.bash_aliases` is typically sourced by default in `~/.bashrc` on Debian/Ubuntu based systems
