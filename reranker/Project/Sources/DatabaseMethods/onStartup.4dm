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

use Q8_0 quantisation

*/

//$folder:=$homeFolder.folder("mmarco-mMiniLMv2-L12-H384-v1")
//$path:="mmarco-mMiniLMv2-L12-H384-v1-Q8_0.gguf"
//$URL:="keisuke-miyako/mmarco-mMiniLMv2-L12-H384-v1-gguf-q8_0"

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-Q8_0.gguf"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-gguf-q8_0"

//$folder:=$homeFolder.folder("bge-reranker-base-gguf")
//$path:="bge-reranker-base-Q8_0.gguf"
//$URL:="keisuke-miyako/bge-reranker-base-gguf-q8_0"

//$folder:=$homeFolder.folder("bge-reranker-large-gguf")
//$path:="bge-reranker-large-Q8_0.gguf"
//$URL:="keisuke-miyako/bge-reranker-large-gguf-q8_0"

//$folder:=$homeFolder.folder("jina-reranker-v1-turbo-en")
//$path:="jina-reranker-v1-turbo-en-Q8_0.gguf"
//$URL:="keisuke-miyako/jina-reranker-v1-turbo-en-gguf-q8_0"

//$folder:=$homeFolder.folder("jina-reranker-v1-turbo-en")
//$path:="jina-reranker-v1-turbo-en-Q8_0.gguf"
//$URL:="keisuke-miyako/jina-reranker-v1-turbo-en-gguf-q8_0"

//$folder:=$homeFolder.folder("Qwen3-Reranker-0.6B")
//$path:="Qwen3-Reranker-0.6B-Q8_0.gguf"
//$URL:="keisuke-miyako/Qwen3-Reranker-0.6B-gguf-q8_0"

//$folder:=$homeFolder.folder("Qwen3-Reranker-4B")
//$path:="Qwen3-Reranker-4B-Q4_k_m.gguf"
//$URL:="keisuke-miyako/Qwen3-Reranker-4B-gguf-q4_k_m"

//$folder:=$homeFolder.folder("Qwen3-Reranker-4B")
//$path:="Qwen3-Reranker-4B-Q8_0.gguf"
//$URL:="keisuke-miyako/Qwen3-Reranker-4B-gguf-q8_0"

//$folder:=$homeFolder.folder("jina-reranker-v2-base-multilingual")
//$path:="jina-reranker-v2-base-multilingual-Q8_0.gguf"
//$URL:="keisuke-miyako/jina-reranker-v2-base-multilingual-gguf-q8_0"

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-F16.gguf"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-gguf-f16"

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-Q8_0.gguf"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-gguf-q8_0"

//$folder:=$homeFolder.folder("jina-reranker-v3")
//$path:="jina-reranker-v3-Q8_0.gguf"
//$URL:="keisuke-miyako/jina-reranker-v3-gguf-q8_0"

//$folder:=$homeFolder.folder("Qwen3-Reranker-0.6B")
//$path:="Qwen3-Reranker-0.6B-Q8_0.gguf"
//$URL:="keisuke-miyako/Qwen3-Reranker-0.6B-gguf-q8_0"

//$folder:=$homeFolder.folder("ctxl-rerank-v2-instruct-multilingual-1b")
//$path:="ctxl-rerank-v2-instruct-multilingual-1b-Q8_0.gguf"
//$URL:="keisuke-miyako/ctxl-rerank-v2-instruct-multilingual-1b-gguf-q8_0"

//$folder:=$homeFolder.folder("ctxl-rerank-v2-instruct-multilingual-1b")
//$path:="ctxl-rerank-v2-instruct-multilingual-1b-Q4_k_m.gguf"
//$URL:="keisuke-miyako/ctxl-rerank-v2-instruct-multilingual-1b-gguf-q4_k_m"

//$folder:=$homeFolder.folder("zerank-1-small")
//$path:="zerank-1-small-Q4_k_m.gguf"
//$URL:="keisuke-miyako/zerank-1-small-gguf-q4_k_m"

//$folder:=$homeFolder.folder("zerank-1-small")
//$path:="zerank-1-small-Q4_k_m.gguf"
//$URL:="keisuke-miyako/zerank-1-small-gguf-q4_k_m-NG"

//$folder:=$homeFolder.folder("bce-reranker-base_v1")
//$path:="bce-reranker-base_v1-Q8_0.gguf"
//$URL:="keisuke-miyako/bce-reranker-base_v1-gguf-q8_0"

//$folder:=$homeFolder.folder("mxbai-rerank-large-v2")
//$path:="mxbai-rerank-large-v2-q8_0.gguf"
//$URL:="keisuke-miyako/mxbai-rerank-large-v2-gguf-q8_0"

$folder:=$homeFolder.folder("bge-reranker-v2-m3")
$path:="bge-reranker-v2-m3-Q8_0.gguf"
$URL:="keisuke-miyako/bge-reranker-v2-m3-gguf-q8_0"

var $huggingface : cs:C1710.event.huggingface
$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path)
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$options:={\
pooling: "rank"; \
log_disable: True:C214; \
reranking: True:C214; \
n_gpu_layers: -1}

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)

/*

ONNX Runtime: 

use int8 quantisation

*/

$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".ONNX")
$port:=8081
$options:={}

//$folder:=$homeFolder.folder("mmarco-mMiniLMv2-L12-H384-v1")
//$path:="mmarco-mMiniLMv2-L12-H384-v1-onnx-int8"
//$URL:="keisuke-miyako/mmarco-mMiniLMv2-L12-H384-v1-onnx-int8"

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-onnx-int8"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-onnx-int8"

//$folder:=$homeFolder.folder("bge-reranker-base")
//$path:="bge-reranker-base-onnx-int8"
//$URL:="keisuke-miyako/bge-reranker-base-onnx-int8"

//$folder:=$homeFolder.folder("keisuke-miyako/bge-reranker-large")
//$path:="bge-reranker-large-onnx-int8"
//$URL:="keisuke-miyako/bge-reranker-large-onnx-int8"

//$folder:=$homeFolder.folder("Qwen3-Reranker-0.6B")
//$path:="Qwen3-Reranker-0.6B-onnx-int8"
//$URL:="keisuke-miyako/Qwen3-Reranker-0.6B-onnx-int8"

//$folder:=$homeFolder.folder("ctxl-rerank-v2-instruct-multilingual-1b")
//$path:="ctxl-rerank-v2-instruct-multilingual-1b-onnx-int8-NG"
//$URL:="keisuke-miyako/ctxl-rerank-v2-instruct-multilingual-1b-onnx-int8-NG"

//$folder:=$homeFolder.folder("jina-reranker-v1-turbo-en")
//$path:="jina-reranker-v1-turbo-en-onnx-int8"
//$URL:="keisuke-miyako/jina-reranker-v1-turbo-en-onnx-int8"

//$folder:=$homeFolder.folder("keisuke-miyako/granite-embedding-reranker-english-r2")
//$path:="granite-embedding-reranker-english-r2-onnx-int8"
//$URL:="keisuke-miyako/granite-embedding-reranker-english-r2-onnx-int8"

//$folder:=$homeFolder.folder("granite-embedding-reranker-english-r2")
//$path:="granite-embedding-reranker-english-r2-onnx-fp16"
//$URL:="keisuke-miyako/granite-embedding-reranker-english-r2-onnx-f16"

//$folder:=$homeFolder.folder("bert-multilingual-passage-reranking-msmarco")
//$path:="bert-multilingual-passage-reranking-msmarco-onnx-f16"
//$URL:="keisuke-miyako/bert-multilingual-passage-reranking-msmarco-onnx-f16"  //model.onnx

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2_f16")
//$path:="ms-marco-MiniLM-L6-v2-onnx-f16"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-onnx-f16"  //model.onnx

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-onnx-int8"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-onnx-int8"

//$folder:=$homeFolder.folder("bge-reranker-v2-gemma")
//$path:="bge-reranker-v2-gemma-onnx-int4-NG"
//$URL:="keisuke-miyako/bge-reranker-v2-gemma-onnx-int4-NG"  //model.onnx

//$folder:=$homeFolder.folder("mxbai-rerank-base-v1")
//$path:="mxbai-rerank-base-v1-onnx-int8"
//$URL:="keisuke-miyako/mxbai-rerank-base-v1-onnx-int8"

//$folder:=$homeFolder.folder("mxbai-rerank-large-v1")
//$path:="mxbai-rerank-large-v1-onnx-f16"
//$URL:="keisuke-miyako/mxbai-rerank-large-v1-onnx-f16"

//$folder:=$homeFolder.folder("mxbai-rerank-base-v1")
//$path:="mxbai-rerank-base-v1-onnx-f16"
//$URL:="keisuke-miyako/mxbai-rerank-base-v1-onnx-f16"

//$folder:=$homeFolder.folder("mxbai-rerank-xsmall-v1")
//$path:="mxbai-rerank-xsmall-v1-onnx-int8"
//$URL:="keisuke-miyako/mxbai-rerank-xsmall-v1-onnx-int8"

//$folder:=$homeFolder.folder("mxbai-rerank-xsmall-v1_f16")
//$path:="mxbai-rerank-xsmall-v1-onnx-f16"
//$URL:="keisuke-miyako/mxbai-rerank-xsmall-v1-onnx-f16"  //model.onnx

//$folder:=$homeFolder.folder("mxbai-rerank-large-v1")
//$path:="mxbai-rerank-large-v1-onnx-int8"
//$URL:="keisuke-miyako/mxbai-rerank-large-v1-onnx-int8"

$folder:=$homeFolder.folder("bge-reranker-v2-m3")
$path:="bge-reranker-v2-m3-onnx-int8"
$URL:="keisuke-miyako/bge-reranker-v2-m3-onnx-int8"

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path; "rerank"; ($URL="@-f16" || ($URL="@-f32")) ? "model.onnx" : "model_quantized.onnx")
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$ONNX:=cs:C1710.ONNX.ONNX.new($port; $huggingfaces; $homeFolder; $options; $event)

/*

CTranslate2: 

use int8 quantisation

*/

$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".CTranslate2")
$port:=8082

//$folder:=$homeFolder.folder("mmarco-mMiniLMv2-L12-H384-v1")
//$path:="mmarco-mMiniLMv2-L12-H384-v1-ct2-int8"
//$URL:="keisuke-miyako/mmarco-mMiniLMv2-L12-H384-v1-ct2-int8"

//$folder:=$homeFolder.folder("ms-marco-MiniLM-L6-v2")
//$path:="ms-marco-MiniLM-L6-v2-ct2-int8"
//$URL:="keisuke-miyako/ms-marco-MiniLM-L6-v2-ct2-int8"

//$folder:=$homeFolder.folder("bge-reranker-base")
//$path:="bge-reranker-base-ct2-int8"
//$URL:="keisuke-miyako/bge-reranker-base-ct2-int8"

//$folder:=$homeFolder.folder("bge-reranker-large")
//$path:="bge-reranker-large-ct2-int8"
//$URL:="keisuke-miyako/bge-reranker-large-ct2-int8"

//$folder:=$homeFolder.folder("bert-multilingual-passage-reranking-msmarco")
//$path:="bert-multilingual-passage-reranking-msmarco-ct2-int8"
//$URL:="keisuke-miyako/bert-multilingual-passage-reranking-msmarco-ct2-int8"

//$folder:=$homeFolder.folder("bce-reranker-base_v1")
//$path:="bce-reranker-base_v1-ct2-int8"
//$URL:="keisuke-miyako/bce-reranker-base_v1-ct2-int8"

$folder:=$homeFolder.folder("bge-reranker-v2-m3")
$path:="bge-reranker-v2-m3-ct2-int8"
$URL:="keisuke-miyako/bge-reranker-v2-m3-ct2-int8"

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path; "rerank")
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$options:={}

$CTranslate2:=cs:C1710.CTranslate2.CTranslate2.new($port; $huggingfaces; $homeFolder; $options; $event)