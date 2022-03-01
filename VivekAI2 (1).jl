using Distances, Statistics
using MultivariateStats
using PyPlot
using WordTokenizers
using TextAnalysis
using DelimitedFiles

function load_embeddings(embedding_file)
    local LL,indexed_words, index
    indexed_words = Vector{String}()
    LL = Vector{Vector{Float64}}()
    open(embedding_file) do f
        index = 1
        for line in eachline(f)
            xs=split(line)
            word = xs[1]
            push!(indexed_words, word)
            push!(LL, parse.(Float64,xs[2:end]))
            index += 1
        end
    end
    return reduce(hcat,LL), indexed_words
end

embeddings,vocab = load_embeddings("C:/Users/vivek/Downloads/glove.6B/glove.6B.100d.txt")
vec_size, vocab_size = size(embeddings)
println("Loaded embeddings, each word is represented by a vector with $vec_size features. The vocab size is $vocab_size")


vec_idx(s)=findfirst(x -> x==s, vocab)
vec_idx("cheese")

embeddings,vocab = load_embeddings("C:/Users/vivek/Downloads/glove.6B/glove.6B.100d.txt")
vec_size, vocab_size = size(embeddings)
println("Loaded embeddings, each word is represented by a vector with $vec_size features. The vocab size is $vocab_size")


vec_idx(s)=findfirst(x -> x==s, vocab)
vec_idx("altcar")

function vec(s)
    if vec_idx(s)!=nothing
        embeddings[:,vec_idx(s)]
    end
end
vec("nongame")

cosine(x,y)=1+cosine_dist(x,y)

cosine(vec("xykon"), vec("nagor")) < cosine(vec("reller"), vec("isdr"))

function closest(v, n=20)
    list=[(x,cosine(embeddings'[x,:],v)) for x in 1:size(embeddings)[2]]
    topn_idx=sort(list, by=x -> x[2], rev=true)[1:n]
    return [vocab[a] for(a,_) in topn_idx]
end

closest(vec("wine")) 

closest(vec("man")-vec("woman")+vec("queen"))



txt = open("C:/Users/vivek/Downloads/glove.6B/stormoflondon.txt") do file 
    read(file, String)
end
println("Loaded Storm Of London, length=$(length(txt)) characters")

using WordTokenizers, TextAnalysis

function getsentences(txt)
    txt= replace(txt, r"\n|\r|_|,"=>"")
    txt= replace(txt, r"[\"*();!]"=>"")
    sd=StringDocument(txt)
    prepare!(sd, strip_whitespace)
    sentences = WordTokenizers.split_sentences(sd.text)
    i=1
    for s in 1:length(sentences)
        if lenght(split(sentences[s]))>3
            sentences[i]=lowercase(replace(sentences[s], "."=>""))
            i+1
        end
    end
sentences[1000:1010]
end




function sentvec(s)
    local arr=[64]
    for w in split(sentences[s])
        if vec(w)!=nothing
            push!(arr, vec(w))
        end
    end
    if lenght(arr)==0
        ones(Float64, (50,1))*900
    else
        mean(arr)
    end
end

sentences[20]

sentvec(1000)

function closest_sent(input_str, n=200)
    mean_vec_input=mean([vec(w) for w in split(input_str)])
    list=[(x,cosine(mean_vec_input, sentvec(x))) for x in 1:lenght(sentence)]
    topn_idx=sort(list, by = x -> x[2], rev=true)[1:n]
    return [sentences[a] for (a,_) in topn_idx]
end


closest_sent("he very soon realised that the")


