from shutil import copy
from subprocess import call, CalledProcessError, check_output, PIPE, Popen, STDOUT, SubprocessError
import os

# Just a thin wrapper over the shell, so we can easily manage dry run modes etc.
class Shell(object):
    def __init__(self, dry = False, verbose = False):
        self.dry = dry
        self.verbose = verbose
        self.dump_actions = dry or verbose

    def mkdir(self, path):
        if self.dump_actions:
            print("mkdir {}".format(path))

        if self.dry:
            return

        os.makedirs(path)

    def copy(self, fromPath, toPath):
        if self.dump_actions:
            print("cp {} {}".format(fromPath, toPath))
        if self.dry:
            return

        copy(fromPath, toPath)

    def run(self, command, directory):
        """
        Run the given command in the given directory and print the stdout and
        stderr. If 'directory' is None, the current working directory is used.
        If an exception is thrown while running the command, it will be rethrown
        as a RuntimeError.
        """
        try:
            if self.dump_actions:
                print(' '.join(command))

            if self.dry:
                return

            with Popen(command, stdout=PIPE, stderr=STDOUT, cwd=directory) as process:
                for line in process.stdout:
                    print(str(line, 'utf-8'), end='')
            if process.returncode != 0:
                raise RuntimeError(
                        "Command failed with return code: {}:\n".format(
                        process.returncode))
        except SubprocessError as exc:
            raise RuntimeError(
                "Error while running command\n{}".format(str(exc.output, 'utf-8'))) from exc

    def run_capture_output(self, command, directory):
        """
        Same as run but returns the output.
        """
        try:
            if self.dump_actions:
                print(' '.join(command))

            if self.dry:
                return

            return str(check_output(command, stderr=STDOUT, cwd=directory), 'utf-8')
        except CalledProcessError as exc:
                raise RuntimeError(
                        "Command failed with return code: {}:\n{}".format(
                        exc.returncode, exc.stdout)) from exc
        except SubprocessError as exc:
            raise RuntimeError(
                "Error while running command\n{}".format(str(exc.output, 'utf-8'))) from exc

    def run_interactive(self, command, directory):
        """
        Same as run but without redirecting any streams.
        """
        try:
            if self.dump_actions:
                print(' '.join(command))

            if self.dry:
                return

            call(command, cwd=directory)
        except SubprocessError as exc:
            raise RuntimeError(
                "Error while running command\n{}".format(str(exc.output, 'utf-8'))) from exc


# Get the full path to the given config file. If the input path is already
# absolute, just return it. Otherwise, try to construct a path relative to the
# directory containing the default config files. If we manage to find an
# existing config file, just return that path. Otherwise, return the default
# config files as suggestions to the user.
def find_config_file(config):
    if os.path.isabs(config):
        return config

    defaultConfigs = os.path.join(
            os.path.dirname(__file__),
            "configs")
    configPath = os.path.join(
            defaultConfigs,
            config)
    if os.path.isfile(configPath):
        return (True, configPath)

    return (False, [os.listdir(defaultConfigs)])
