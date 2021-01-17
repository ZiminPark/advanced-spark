메모리 문제 : free -m , config 설정 <br>
split vs span : split은 string에서 쓸 수 있다. 인자 기준으로 자른다. python이랑 같음. 이상하게 " "도 괜찮고 ' '도 괜찮다. 
span은 collection에서 쓸 수 있나? 인자로 predicator를 받는다. partition하는 것과 비슷 [링크](https://alvinalexander.com/scala/how-to-split-sequences-subsets-groupby-partition-scala-cookbook/)

<br>
broadcast : 잘 이해 못함. 82쪽 <br>
\_* 문법 : python asterisk랑 비슷한듯. split, artistById.filter($"id" isin (recoArtistIDs:_*)).show() 
```Scala
def echo(args: String*) = 
    for (arg <- args) println(arg)

val arr = Array("What's", "up", "doc?")
echo(arr: _*)
```


trainData 에서 cache 사용하는 이유? <br>
=== vs == : [링크](https://stackoverflow.com/questions/39490236/difference-between-and-in-scala-spark) <br>
model.itemFactors.select($"id".as("artist")) : $는 왜 붙이는건지? <br>
head, take, show, limit 차이
