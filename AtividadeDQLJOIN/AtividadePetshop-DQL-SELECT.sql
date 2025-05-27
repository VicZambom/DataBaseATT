-- Victoria De Gouveia Zambom
Use petshop;
/*Relatório 1 - Lista dos empregados admitidos entre 2024-01-01 e 2023-05-03,
trazendo as colunas (Nome Empregado, CPF Empregado, Data Admiisvão,  Salário, 
Departamento, Número de Telefone), ordenado por data de admiisvão decrescente;*/
select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", emp.dataAdm "Data Admiisvão", emp.salario "Salário", dep.nome "Departamento", 
		ifnull(group_concat(distinct tel.numero separator ' | '),"Não Informado") "Número de Telefones"
		from empregado emp
		  left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
           left join telefone tel on tel.Empregado_cpf = emp.cpf
			where dataAdm between "2023-01-01" and "2024-03-31"
			group by emp.cpf, emp.nome, emp.sexo, emp.salario
             order by dataAdm desc;
/*Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop,
trazendo as colunas (Nome Empregado, CPF Empregado, Data Admiisvão,  Salário, 
Departamento, Número de Telefone), ordenado por nome do empregado;*/			
select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", emp.dataAdm "Data Admiisvão", emp.salario "Salário", dep.nome "Departamento", 
		ifnull(group_concat(distinct tel.numero separator ' | '),"Não Informado") "Número de Telefones"
		from empregado emp
		  left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
           left join telefone tel on tel.Empregado_cpf = emp.cpf
			where salario < (select avg(salario) from empregado)
			group by emp.cpf, emp.nome, emp.sexo, emp.salario
             order by emp.nome;
/*Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, 
trazendo também a média salarial dos funcionários do departamento e a média de comiisvão recebida pelos empregados do departamento, 
com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comiisvão), ordenado por nome do departamento;*/
select dep.nome "Departamento", count(emp.Departamento_idDepartamento) "Quantidade de Empregados", avg(emp.salario) "Média Salarial", avg(comissao)"Média Comiisvão"
	from departamento dep
		left join empregado emp on emp.Departamento_idDepartamento = dep.idDepartamento
			group by dep.nome
				order by dep.nome;
/*Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado,além da soma do 
valor total das vendas do empregado e a soma de suas comiisvões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo,
Salário, Quantidade Vendas, Total Valor Vendido, Total Comiisvão das Vendas), ordenado por quantidade total de vendas realizadas;*/
select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", replace(replace(emp.sexo, 'F', "Feminino"),'M', "Masculino") "Gênero", emp.salario "Salário",
		count(vnd.idVenda)"Quantidade de Vendas", (sum(vnd.valor)-sum(vnd.desconto))"Valor Total Vendido", sum(vnd.comissao)"Total de Comiisvão em Vendas"
	from empregado emp
		inner join venda vnd on vnd.Empregado_cpf = emp.cpf
			group by emp.cpf, emp.nome, emp.sexo, emp.salario
				order by "Quantidade de Vendas" asc;
/*Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas
 com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas
 por empregado e a soma de suas comiisvões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário,
 Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comiisvão das Vendas com Serviço),
 ordenado por quantidade total de vendas realizadas;*/
 select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", replace(replace(emp.sexo, 'F', "Feminino"),'M', "Masculino") "Gênero", emp.salario "Salário",
		count(distinct isv.Venda_idVenda) "Quantidade Total de Vendas com Serviço",
        sum(isv.valor * isv.quantidade - ifnull(vnd.desconto, 0)) "Valor Total Vendido com Serviço",
        sum(vnd.comissao)"Valor Total Comiisvão de Vendas com serviço"
	from empregado emp
		 inner join itensservico isv on isv.Empregado_cpf = emp.cpf
		 inner join venda vnd on isv.Venda_idVenda = vnd.idVenda
			group by emp.cpf, emp.nome, emp.sexo, emp.salario
				order by "Quantidade Total de Vendas com Serviço" asc;
/* Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço,
Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga;*/
-- alter table petshop.venda change column `data` `dataVenda` datetime not null ;
select pet.nome "Nome Pet",  date_format(vnd.dataVenda , '%d/%m/%Y') "Data do Serviço", ss.nome "Nome do Serviço", isv.valor "Valor" ,isv.quantidade "Quantidade",
	   emp.nome "Empregado que realizou o Serviço"
	from itensservico isv
		join empregado emp on emp.cpf = isv.Empregado_cpf
        join servico ss on ss.idServico = isv.Servico_idServico
        join venda vnd on vnd.idVenda = isv.Venda_idVenda
        join pet on pet.idPet = isv.PET_idPet
				order by vnd.dataVenda desc;
/*Relatório 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que
 realizou a venda), ordenado por data do serviço da mais recente a mais antiga;*/
 select cliente.nome "Cliente",  date_format(vnd.dataVenda , '%d/%m/%Y') "Data da Venda", vnd.valor "Valor", vnd.desconto "Valor de Desconto",
		sum(vnd.valor - ifnull(vnd.desconto, 0)),
	   emp.nome "Empregado que realizou o Serviço"
	from venda vnd
		join cliente on cliente.cpf = Cliente_cpf
        join empregado emp on emp.cpf = vnd.Empregado_cpf
			group by emp.nome, cliente.nome, vnd.DataVenda, vnd.valor, vnd.desconto
			order by vnd.dataVenda desc;
/*Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido,
 trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;*/
 select servico.nome "Nome do Serviço", count(isv.Servico_idServico )"Quantidade de Vendas", sum(isv.valor * isv.quantidade)"Valor Total Vendido"
	from servico
		join itensservico isv on isv.Servico_idServico = servico.idServico
			group by servico.nome
				order by count(isv.Servico_idServico) desc
					limit 10;
/*Relatorio 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi relacionada, trazendo as colunas
 (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;*/
 select fpg.tipo "Tipo da Forma Pagamento", count(fpg.Venda_idVenda) "Quantidade Vendas", sum(fpg.valorPago)"Valor Total Vendido"
	from formapgvenda fpg
		group by fpg.tipo
			order by count(fpg.Venda_idVenda) desc;
/*Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda),
ordenado por Data Venda da mais recente a mais antiga*/
select vnd.dataVenda "Data Venda", count(idVenda) "Quantidade de Vendas", sum(vnd.valor - ifnull(vnd.desconto, 0))"Valor Total Venda"
	from venda vnd
		group by vnd.dataVenda
			order by vnd.dataVenda;
/*Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, marca do Produto, Nome Fornecedor,
 Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;*/
select f.nome "Fornecedor", pd.nome "Produto", format(pd.valorVenda, 2, 'de_DE') "Valor Produto R$)", pd.marca "Marca do Produto",
    f.email "Email Fornecedor", ifnull(tel.numero, "Não Informado")"Telefone Fornecedor"
		from produtos pd
			left join itenscompra ic on ic.Produtos_idProduto = pd.idProduto
			join compras comp on comp.idCompra = ic.Compras_idCompra
			join fornecedor f on f.cpf_cnpj = comp.Fornecedor_cpf_cnpj
			left join telefone tel on tel.Fornecedor_cpf_cnpj = f.cpf_cnpj
					order by f.nome;
