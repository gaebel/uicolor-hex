# UIColor Hex

> UIColor Hex is a simple command line interface tool written in Ruby, which takes a hexadecimal number as an argument and returns the RGB UIColor snippet. 

## Installation

Install uicolor-hex using Ruby Gems.
```
gem install uicolor-hex
```

## Commands

```
uihex convert
```
Converts the hex argument to the UIColor snippet. You can define a set of options like copying to clipboard, using floating point numbers (instead of a divisor), and the floating point precision. For more details about the options see below.  
   
```
uihex config
```
Defines options as default value and persists them.

## Options

| Name | Description                               | Input | Default |
| ---- | ----------------------------------------- | ----- | ------- |
| -a   | Sets the alpha value                      | Float |         |
| -c   | Copy snippet to clipboard                 | Bool  | false   |
| -f   | Use floating points instead of a divisor  | Bool  | false   |
| -p   | Defines the floating point precision      | Int   | 2       |
| -v   | Returns the script version                |       |         |
| -h   | Shows the manual                          |       |         |

## Usage

```
> uihex convert EC5600 -a 0.8 -c 
UIColor(red: 236/255, green: 86/255, blue: 0/255, alpha: 0.8)
Copied to clipboard ✨
> uihex convert '#EC5600' -f -p 2 
UIColor(red: 0.93, green: 0.34, blue: 0.0, alpha: 1.00)
```

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
