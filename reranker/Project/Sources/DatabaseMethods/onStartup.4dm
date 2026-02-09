/*

llama-server settings

*/

var $llama : cs:C1710.llama.llama
var $homeFolder : 4D:C1709.Folder
$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".GGUF")
$port:=8080

/*

callbacks for downloader (alert on error)

*/

var $event : cs:C1710.event.event
$event:=cs:C1710.event.event.new()
$event.onError:=Formula:C1597(ALERT:C41($2.message))
//$event.onSuccess:=Formula(ALERT($2.models.extract("name").join(",")+" loaded!"))
$event.onData:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onResponse:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":download complete"))
$event.onTerminate:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $1.pid; "terminated!"].join(" "))))

var $options : Object
var $huggingfaces : cs:C1710.event.huggingfaces
var $folder : 4D:C1709.Folder
var $path : Text
var $URL : Text
var $pooling : Text

/*

model settings (llama.cpp)

*/

$folder:=$homeFolder.folder("bge-reranker-v2-m3")  //where to keep the repo
$path:="bge-reranker-v2-m3-Q8_0.gguf"  //path to the file
$URL:="keisuke-miyako/bge-reranker-v2-m3-gguf-q8_0"  //path to the repo

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")  //where to keep the repo
//$path:="ms-marco-MiniLM-L6-v2-Q8_0.gguf"  //path to the file
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-gguf-q8_0"  //path to the repo

//$folder:=$homeFolder.folder("jina-reranker-v1-turbo-en")  //where to keep the repo
//$path:="jina-reranker-v1-turbo-en-Q8_0.gguf"  //path to the file
//$URL:="keisuke-miyako/jina-reranker-v1-turbo-en-gguf-q8_0"  //path to the repo

$batch_size:=8194
$ubatch_size:=8194  //max_position_embeddings
$pooling:="rank"
$n_gpu_layers:=-1

var $huggingface : cs:C1710.event.huggingface
$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path)
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$options:={\
embeddings: True:C214; \
pooling: $pooling; \
batch_size: $batch_size; \
ubatch_size: $ubatch_size; \
threads: 4; \
threads_batch: 4; \
threads_http: 4; \
log_disable: True:C214; \
reranking: True:C214; \
n_gpu_layers: $n_gpu_layers}

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)

$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".ONNX")
$port:=8081

$folder:=$homeFolder.folder("bge-reranker-v2-m3")  //where to keep the repo
$path:="bge-reranker-v2-m3-onnx"  //path to the file
$URL:="keisuke-miyako/bge-reranker-v2-m3-onnx"  //path to the repo

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path; "rerank"; "model_quantized.onnx")
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$options:={}

$ONNX:=cs:C1710.ONNX.ONNX.new($port; $huggingfaces; $homeFolder; $options; $event)