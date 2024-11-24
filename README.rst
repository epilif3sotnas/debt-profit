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

|nbsp|


.. list-table:: Investment Command Args
    :header-rows: 1

    *   - Arg
        - Data Type
    *   - starting-amount
        - f64
    *   - contribution
        - f64
    *   - duration
        - f32
    *   - apy
        - u16

.. list-table:: Debt Command Args
    :header-rows: 1

    *   - Arg
        - Data Type
    *   - amount
        - f64
    *   - interest
        - f32
    *   - duration
        - u16

.. list-table:: Both Command Args
    :header-rows: 1

    *   - Arg
        - Data Type
    *   - starting-amount
        - f64
    *   - contribution
        - f64
    *   - duration
        - f32
    *   - apy
        - u16
    *   - amount
        - f64
    *   - interest
        - f32
    *   - duration
        - u16


|nbsp|


License
#######

Licensed under Apache-2.0 license.