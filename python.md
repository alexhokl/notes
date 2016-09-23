##### Getting class name
```py
variable_name.__class__.__name__
```

##### Look up exception on StackOverflow
```py
# python 2.7
import webbrowser
from urlparse import urlparse

try:
    10 / 0
except Exception as E:
    url = 'http://stackoverflow.com/search?q=' + urlparse('Python %s' % E).geturl()
    print(url)
    webbrowser.open(url)
```
