- [GPS](#gps)
  * [Links](#links)
___

# GPS

## Links

- [GPS by Bartosz Ciechanowski](https://ciechanow.ski/gps/) - this link contains
  interactive visualizations and it should help understanding the notes here
  * in a 2D plane, using a rope and two reference points should be enough to
    guess the position (by drawing two circles and there are two intersecting
    points)
    + [Simple Positioning](https://ciechanow.ski/gps/#simple-positioning)
  * in a 2D plane, if a rope is replaced by waves, we can measure the distances
    by using time; however, the system time (of reference points) and the time of
    the position to be measured (receiver) may not be synchronized; thus,
    3 references points are required (since the unknown drift of the time is
    constant relative to the 3 reference points)
    + [Time of Flight](https://ciechanow.ski/gps/#time-of-flight)
    + [Do you hear me?](https://ciechanow.ski/gps/#do-you-hear-me)
  * in a 3D space, 4 reference points are required to guess the position (either
    above ground or below ground)
    + [Leveling Up](https://ciechanow.ski/gps/#leveling-up)
  * reference points has to be above ground to prevent obstacles
    + [Higher, Better, Faster,
      Stronger](https://ciechanow.ski/gps/#higher-better-faster-stronger)
  * orbits cannot be on equator only as there is no way to distinguish the
    longitude (as in in nothern hemisphere or southern hemisphere)
    + [Orbiting](https://ciechanow.ski/gps/#orbiting)
  * the orbits are not circular but elliptical (and not perfectly elliptical);
    there are 6 orbits and they are evenly distributed by 60 degrees; the
    satellites in the orbits are not evenly distributed and there are 30 active
    GPS satellites (previously 24)
    + [GPS Orbits](https://ciechanow.ski/gps/#gps-orbits)
  * there are many factors that make it difficult to determine the exact
    position
    + time of clock in satellites may not be perfectly synchronized (it drifts
      during its flight in space and it has to be adjusted by connection to ground
      stations every 2 hours
    + signal can be affected by refraction (ionosphere and troposphere)
    + the orbital elements and their rates are also measured with some degree of
      uncertainty
    + because of the above uncertainties, the receiver is not dealing with
      exact distances but range of distances; and that is the reason GPS
      position shown on a map is always a circle (but not a point)
    + [Signal Propagation](https://ciechanow.ski/gps/#signal-propagation)
