Svirneblin Network Monitoring and Local Vulnerability Evaluation Toolkit
========================================================================

This is a tool for enumerating the hosts on a local network and for evaluating
the security of those hosts in a quick, automatic way. It just generates tiers
of menus which enumerate local hosts and the services running on those hosts.
Optionally, if it finds scripts which exploit potential vulnerabilities in those
services in a directory(Either /usr/bin/exploits or $HOME/.bin/exploits) it will
generate a menu for launching those scripts in a terminal under the enumerated
services in the menu. It's not compatible with any existing vulnerability
framework, but it shouldn't be particularly difficult to wrap your applications
up in the exploits/ folder. An example script exploiting the shellshock
vulnerability will be included as an example shortly.
