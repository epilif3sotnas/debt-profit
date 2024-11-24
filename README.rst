.. |nbsp| unicode:: 0xA0
   :trim:


About debt-profit
=================

This little calculator was done with the goal of learning Zig programming language and also to create a calculator to check if a certain loan is profitable when invested against investing an amount of X every month.

|nbsp|


Requirements
############

**Zig => build.zig.zon**

|nbsp|


Run
###

Commands to run the project:

.. code-block:: bash

    cd {PATH_REPOSITORY};
    zig build run -- both --starting-amount=10 --debt-amount=100 --duration=12 --apy=10.2 --interest=12.2 --contribution=100;
    zig build run -- investment --starting-amount=10 --duration=12 --apy=10.2 --contribution=100;
    zig build run -- debt --amount=100 --duration=12 --interest=12.2;

.. list-table:: Investment Command Args
    :header-rows: 1
    :widths: 50 50

    * - Column 1
        - Column 2
    * - Row 1
        - Value 1
    * - Row 2
        - Value 2
    * - Row 3
        - Value 3

|nbsp|


License
#######

Licensed under Apache-2.0 license.