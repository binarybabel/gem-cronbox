# Cronbox

**Command-line inbox and timecard for scheduled job status and output.**

[![Gem Version](https://badge.fury.io/rb/cronbox.svg)](https://badge.fury.io/rb/cronbox) [![Build Status](https://travis-ci.org/binarybabel/gem-cronbox.svg?branch=master)](https://travis-ci.org/binarybabel/gem-cronbox)

Run any command through Cronbox to store its exit status and output for later review and diagnostics. Data is stored as JSON with a default location of `$HOME/.cronbox`

**Just prefix scheduled commands with `cb`**

    $ cb /usr/bin/rsync -rav something somewhere
    
**And review the results later, with full output available:**

```
$ cb
| Cronbox |                                                     *=Output
========================================================================
| ID | COMMAND                                 | EXIT |           WHEN |
========================================================================
|  1 | /usr/bin/rsync -rav something somewhere |    0 |  2 minutes ago |
------------------------------------------------------------------------
|  2 | ~/Dropbox/bin/run-daily-backup          |   *0 |    8 hours ago |
------------------------------------------------------------------------
```

## Installation

    $ gem install cronbox

## Usage

For complete usage options, please consult `cb --help`

    $ cb                  # Print the cronbox index timecard
    $ cb CMD [ARGS]       # Run and record output of command
    $ cb -o ID            # Review command output of entry
    
### CRONTAB USAGE & RVM

If you're using RVM to manage Ruby, Cronbox may not be available inside crontab due to missing paths. Try adding the following two options to the top of your crontab file...

```
SHELL=/bin/bash
BASH_ENV=$HOME/.profile
* * * * * cb true          # Cronbox testing
```

* Depending on your OS/Environment you might need `.bash_profile` instead. 
* The `cb true` test line should show up on your Cronbox timecard.
  * Once it does you'll know you have everything working correctly and can remove it.

## Contributing

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Bug reports and pull requests are welcome on GitHub at https://github.com/binarybabel/gem-cronbox.

* After checking out the repo, run `bin/setup` to install dependencies.
* Then, run `rake test` to run the tests.

## Author and License

 - **Author:** BinaryBabel OSS ([https://keybase.io/binarybabel](https://keybase.io/binarybabel))
 - **License:** GNU GPL 3

                                                                                 0101010            
                                                                              0010011               
                                                                            110101                  
                                                                          0011                      
             __   __   __        __   __                                           0100010          
            /  ` |__) /  \ |\ | |__) /  \ \_/                         1010    0010101000001         
            \__, |  \ \__/ | \| |__) \__/ / \                       010101110100111101010010        
                                                                   01     0011000100                
                A BinaryBabel OSS Project                                                           
                                                                     0100                           
                                                                  01001001    binarybabel.org       
                                                                 0100111001    000001010001110      
                                                                101       0010010000010100100101    
                                                            00111          0010011110100011001010   
                                                            0110            10000010100111001000100 

