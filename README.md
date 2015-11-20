I wanted to learn Swift. I also wanted to learn how base64 encoding works. Now I understand the latter and am just a tad less terrible at the former.

[First relevant image](Screen Shot 2015-11-19 at 20.55.02.png)  
[Second relevant image](Screen Shot 2015-11-19 at 20.55.54.png)  

I know that there are base64 functions in Foundation and even a base64 utility in OS X but I wanted to implement the juicy part of radix 64 encoding myself. These kinds of concepts are easier for me to understand if I implement them from scratch.

I\ve re-implemented the logic to use lower level operations. I wanted to see how bit manipulation worked in Swift and I found out it works just as you'd expect if you've ever done bitwise logic in any C-like language. Here are benchmarks from testing on a larger (?) image:
```
String version took 11.3489139676094
Binary version took 1.38903999328613
```

Needless to say the binary version is ~10x faster. Check early commits for sluggish string version if you dare.
