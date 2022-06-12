show dbs;

db.produto.insertOne({_id: "1", 
                     nome: "cpu i5",
                      "qtd": "15" });

db.produto.insertOne({id: 2, nome: "memória ram", qtd: 10, descricao: {armazenamento: "8GB", tipo:"DDR4"}});

db.produto.insertMany(
[{ _id: 3, nome: "mouse", qtd: 50, descricao: {conexao: "USB", so: ["Windows", "Mac", "Linux"]}},
{ _id: 4, nome: "hd externo", "qtd": 20, descricao: {conexao: "USB", armazenamento: "500GB", so: ["Windows 10", "Windows 8", "Windows 7"]}}]
);


/* #Nome = mouse */
db.produto.find({nome:"mouse"})

/* Quantidade = 20 e apresentar apenas o campo nome */
db.produto.find({qtd:20},{nome:1})

/* #Quantidade <= 20 e apresentar apenas os campos nome e qtd*/
db.produto.find({qtd:{$lt:20}},{nome:1, qtd:1})

/* Quantidade entre 10 e 20 */
db.produto.find({  qtd: {  $gte: 10,    $lte: 20   } })


/*Conexão = USB e não apresentar o campo _id e qtd */
db.produto.find({ "descricao.conexao" : "USB"}, {_id:0,qtd:0})

/* SO que contenha “Windows” ou “Windows 10” */
db.produto.find({"descricao.so": {$in:["Windows 10","Windows"]}})
//Mostrar os documentos ordenados pelo nome em ordem alfabética.
db.produto.find().sort({nome:1})

//Mostrar os 3 primeiros documentos ordenados por nome e quantidade.
db.produto.find().sort({nome:1,qtd:1}).limit(3)

//Mostrar apenas 1 documento que tenha o atributo Conexão = USB.
db.produto.find({"descricao.conexao":"USB"}).limit(1)

// Mostrar os documentos de tenham o atributo conexão = USB e quantidade menor que 25.
db.produto.find({ "descricao.conexao":"USB",qtd:{$lt:25}
                })

//Mostrar os documentos de tenham o atributo conexão = USB ou quantidade menor que 25.
db.produto.find({ $or:[{"descricao.conexao":"USB"},{qtd:{$lt:25}}
                      ]})


// Mostrar apenas os id dos documentos de tenham o atributo conexão = USB ou quantidade menor que 25.
db.produto.find({ $or:[{"descricao.conexao":"USB"},{qtd:{$lt:25}}
                      ]},{_id:1})


//Mostrar todos os documentos da collection produto do banco de dados seu nome
db.produto.find({})

//2. Atualizar o valor do campo nome para “cpu i7” do id 1
db.produto.updateOne({_id:"1"},{$set:{nome:"cpu i7"}})

//3. Atualizar o atributo quantidade para o tipo inteiro do id: 1
db.produto.updateOne({_id:"1"},{$set:{qtd:1}})

//4. Atualizar o valor do campo qtd para 30 de todos os documentos, com o campo qtd >= 30
db.produto.updateMany({qtd:{$lte:30}},{$set:{qtd:30}})


//5. Atualizar o nome do campo “descricao.so” para “descricao.sistema” de todos os documentos
db.produto.updateMany({},{$rename:{"descricao.so":"descricao.sistema"}})

//6. Atualizar o valor do campo descricao.conexao para “USB 2.0” de todos os documentos, com o campo descricao.conexão = “USB”
db.produto.updateMany({"descricao.conexao":"USB"},{$set:{"descricao.conexao":"USB 2.0"}})

//7. Atualizar o valor do campo descricao.conexao para “USB 3.0” de todos os documentos, com o campo descricao.conexao = “USB 2.0” 
//e adicionar o campo “data_modificacao”, com a data da atualização dos documentos
db.produto.updateMany({"descricao.conexao":"USB 2.0"},{$set:{"descricao.conexao":"USB 3.0", "data_modificacao": new Date()}})
db.produto.updateMany({"descricao.conexao":"USB 3.0"},{$set:{"descricao.conexao":"USB 3.0"},
                                                      $currentDate:{data_modificacao: true}
                                                       })


//8. Atualizar um dos elementos do array descricao.sistema de “Windows” para “Windows 10” do id 3
db.produto.updateOne({_id:3, "descricao.sistema": "Windows"},{$set:{"descricao.sistema.$":"Windows 10"}})

//9. Acrescentar o valor “Linux” no array descricao.sistema do id 4
db.produto.updateOne({_id:4},{$push:{"descricao.sistema":"Linux"}})

//10. Remover o valor “Mac” no array descricao.sistema do id 3 e adicionar o campo “ts_modificacao”, com o timestamp da atualização dos documentos
db.produto.updateOne({_id:3},{$pull:{"descricao.sistema":"Mac"}})


//1. Mostrar todos os documentos da collection produto do banco de dados seu nome
db.produto.find({})

//2. Buscar os documentos com o atributo nome,  que contenham a palavra “cpu”
db.produto.find({nome: {$regex:"cpu"}})

//3. Buscar os documentos  com o atributo nome, que começam por “hd” e apresentar os campos nome e qtd
db.produto.find({nome: {$regex: /^hd/}},{qtd:1,nome:1})

//4. Buscar os documentos  com o atributo descricao.armazenamento, que terminam com “GB” ou “gb” e apresentar os campos nome e descricao
db.produto.find({"descricao.armazenamento": {$regex: /GB/i}},{descricao:1,nome:1})

//5. Buscar os documentos  com o atributo nome, que contenha a palavra memória, ignorando a letra “o”
db.produto.find({"nome": {$regex: /mem.ria/}})

//6. Buscar os documentos  com o atributo qtd  que contenham valores com letras, ao invés de números.
db.produto.find({"qtd": {$regex: /[a-z]/}})


//7. Buscar os documentos com o atributo descricao.sistema, que tenha exatamente a palavra “Windows”
db.produto.find({"descricao.sistema": "Windows"})

// TODOS OS niveis existentes
db.alunos.distinct("nivel")

// Visualizar os valores únicos do “nivel” de cada “ano_ingresso”
db.alunos.aggregate([{ $group: {_id: { ano_ingresso: "$ano_ingresso"},
                     "nivel_ano": { $addToSet: "$nivel"   }  }
                     }])

// Calcular a quantidade de alunos matriculados por cada “id_curso”
db.alunos.aggregate([{ $group: {_id: { id_curso: "$id_curso"},
                     "total": { $sum: 1   }  }
                     }])

//6. Calcular a quantidade de alunos matriculados por “ano_ingresso” no "id_curso“: 1222
db.alunos.aggregate([{ $match:{id_curso:1222}}, 
                     { $group: {_id: { ano: "$ano_ingresso"},
                     "total": { $sum: 1   }  }
                     }])
                     
                     
//7. Visualizar todos os documentos do “nível”: “M”
db.alunos.find({nivel:"M"})


//8. Visualizar o último ano que teve cada curso (id_curso) dos níveis “M”
db.alunos.aggregate([{$match:{nivel:"M"}},
                     { $group: {_id: { id_curso: "$id_curso"},
                     "ultimo_ano": { $max: "$ano_ingresso"   }  }
                     }])

//9. Visualizar o último ano que teve cada curso (id_curso) dos níveis “M”, ordenados pelos anos mais novos de cada curso
db.alunos.aggregate([{$match:{nivel:"M"}},
                     { $group: {_id: { id_curso: "$id_curso"},
                     "ultimo_ano": { $max: "$ano_ingresso"   }  }
                     },
                     {$sort:{"ultimo_ano":-1}} // ordenar do agrupamento
                     ])



//10. Visualizar o último ano que teve os 5 últimos cursos (id_curso) dos níveis “M”, ordenados pelos anos mais novos
db.alunos.aggregate([{$match:{nivel:"M"}},
                     { $group: {_id: { id_curso: "$id_curso"},
                     "ultimo_ano": { $max: "$ano_ingresso"   }  }
                     },
                     {$sort:{"ultimo_ano":-1}}, // ordenar do agrupamento
                     {$limit:5}
                     ])
					 
					 
db.alunos.aggregate([{
    $lookup: {
        from: 'cursos',
        localField: 'id_curso',
        foreignField: 'id_curso',
        as: 'alunos_cursos'
    }
}, {
    $project: {
        id_discente: 1,
        nivel: 1,
        'alunos_cursos.id_curso': 1,
        'alunos_cursos.nome': 1
    }
}])     