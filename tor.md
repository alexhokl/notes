- [Concepts](#concepts)
- [Others](#others)
____

## Concepts

- [3 types of relay](https://community.torproject.org/relay/types-of-relays/)
  - guard
    - encrypt traffic from clients or bridges and relay to middle relays
  - middle
  - exit
    - sends traffic out to destination
- [bridge](https://community.torproject.org/relay/types-of-relays/#bridge)
  - it is needed as there are censorships blocking IP address of public Tor
    relays and, even for private (hidden) Tor relays, censorships can
    identify the traffic by using deep packet inspection and eventually blocking
    the traffic to the relay (see
    [reference](https://www.technologyreview.com/2012/04/04/186902/how-china-blocks-the-tor-anonymity-network/)).
    Thus, a private bridge and obfuscation are needed to ensure traffic and IP
    address of both bridge and relay associated will be much harder to be
    identified.
  - [installation guides](https://community.torproject.org/relay/setup/bridge/)
  - [find a bridge and use a bridge](https://bridges.torproject.org/)
  - [manual](https://tb-manual.torproject.org/bridges/)
  - [moat](https://support.torproject.org/glossary/moat/) - an interactive tool
    you can use to get bridges from within Tor Browser. It uses domain fronting
    to help you circumvent censorship. Moat also employs a Captcha to prevent
    a censor from quickly blocking all of the bridges
- [orbot](https://play.google.com/store/apps/details?id=org.torproject.android)
  - covering non-browser traffic on Android
- [Snowflake](https://snowflake.torproject.org/)
  - acts as a proxy relaying traffic to a bridge

## Others

- [Using Tor in
  some countries](https://medium.com/@phoebecross/using-tor-in-china-1b84349925da) - this
  is an older post but some of the techniques are still relevant
