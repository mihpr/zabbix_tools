$ cat $(which vldiff)
#!/bin/bash

dwdiff --color=bred,bgreen -d ',;&*()[]{}=".' --diff-input $@