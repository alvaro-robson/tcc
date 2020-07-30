create database banco_ccmed;
use banco_ccmed;
-- -------------------------------------------------------------
create table ACESSO
(
	id_acesso int(4) primary key auto_increment,
    tipo_acesso varchar(20)not null,
    desc_acesso varchar (300) not null
);
insert into ACESSO(tipo_acesso, desc_acesso)values
('Obra', 'Acesso a consultas e pedidos de materiais do estoque'),
('Estoque', 'Acesso à consultas, reservas e liberação de pedidos e cadastros de materiais e fornecedores'),
('Administrador', 'Acesso à todas as informações do sistema, como consultas, cadastro de materiais, fornecedores e novos usuários');
SELECT*FROM ACESSO;
-- -------------------------------------------------------------
create table USUARIO
(
	id_usuario int primary key auto_increment,
    login varchar(20) not null,
    senha varchar (100) not null,
    nome varchar (100) not null,
    sobrenome varchar (100) not null,
    matricula int(4) not null unique,
    id_acesso_fk int(4) not null,
    constraint foreign key(id_acesso_fk)references ACESSO(id_acesso) on delete cascade
);
insert into USUARIO(login, senha, nome, sobrenome, matricula, id_acesso_fk)
VALUES
-- login	senha		nome		sobrenome	matricula	id_acesso
('jose', 	'1234', 	'José', 	'Silva', 	'998',  	'1'),
('joao',	'1111', 	'João', 	'Santos',	'2228',    	'1'),
('kl', 		'4321', 	'Kleber', 	'Alves',	'221',   	'2'),
('fernando','3344',		'Fernando', 'Souza',	'989',   	'2'),
('marcio',	'989898',	'Marcio', 	'Freitas',	'134',  	'2'),
('matheus', '3331234', 	'Matheus', 	'Castro',	'11',	    '3'),
('jorge',	'9994',		'Jorge', 	'Santana',	'98',    	'3');
SELECT*FROM USUARIO;
-- -------------------------------------------------------------
create table PEDIDO
(
	id_pedido int(4) primary key auto_increment,
    data_abertura timestamp default current_timestamp,
    vencimento timestamp default current_timestamp, /*A exibição da data de expiração do pedido
    será alterada nas queries com data_add. Exemplo: a última query desta atividade*/
    data_fechamento datetime null,
    status_pedido varchar(20) not null,
    id_usuario_fk int(4) not null,
    constraint foreign key(id_usuario_fk)references USUARIO(id_usuario)
); 
insert into PEDIDO(status_pedido, id_usuario_fk)values
('aberto', 	'1'),
('aberto',	'1'),
('aberto',	'2'),
('aberto',	'3'),
('aberto',	'4'),
('aberto', '4'),
('aberto',	'5'),
('aberto',	'5'),
('aberto',	'6'),
('aberto',	'6'),
('aberto',	'7'),
('aberto',	'7');
/*Obs: quando o usuario  fechar o pedido, no mesmo comando terão: atualização do status de aberto para fechado
e inserção da data atual no campo data_fechamento através da função 'now()' */

/*Os comandos abaixo são para simular o fechamento desses pedidos, como explicado acima. Será atualizado
o status para fechado e o "now()" pegará data e hora do momento em que o usuário finalizar o pedido e 
preencherá o campo data_fechamento*/
update PEDIDO set data_fechamento = now() where id_pedido = 6;
update PEDIDO set data_fechamento = now() where id_pedido = 7;
update PEDIDO set data_fechamento = now() where id_pedido = 8;
update PEDIDO set data_fechamento = now() where id_pedido = 10;
update PEDIDO set data_fechamento = now() where id_pedido = 11;
update PEDIDO set status_pedido = 'fechado' where id_pedido = 6;
update PEDIDO set status_pedido = 'fechado' where id_pedido = 7;
update PEDIDO set status_pedido = 'fechado' where id_pedido = 8;
update PEDIDO set status_pedido = 'fechado' where id_pedido = 10;
update PEDIDO set status_pedido = 'fechado' where id_pedido = 11;

select*from PEDIDO;
-- -------------------------------------------------------------

-- Query para testar a junção das tabelas PEDIDO e LIDER_USUARIO:
select
P.id_pedido 'Código do pedido', P.data_abertura 'Data de abertura', date_add(P.vencimento, interval 7 day) 'Vencimento',
U.id_usuario 'Código do usuário', nome'Nome do requisitante', matricula 'Matrícula do requisitante'
from PEDIDO as P
inner join USUARIO as U
on P.id_usuario_fk = U.id_usuario;
-- fim
-- -------------------------------------------------------------
create table DETALHE_PEDIDO
(
	id_detalhe int primary key auto_increment,
    qtde int(4) not null,
    id_mat_fk int(4) not null,
    id_pedido_fk int(4) not null,
    constraint foreign key (id_pedido_fk)references PEDIDO(id_pedido) on delete cascade,
    constraint foreign key (id_mat_fk)references MATERIAL(id_mat)
); 
insert into DETALHE_PEDIDO(qtde, id_mat_fk, id_pedido_fk)values
(3, 	12,	1),
(10, 	11, 2),
(20, 	10, 3),
(8, 	9,	4),
(12, 	8,	5),
(4, 	7,	6),
(6, 	6,	7),
(14, 	5,	8),
(19, 	4,	9),
(20, 	3,	10),
(2, 	2,	11),
(3, 	1,	12),
(3, 	2,	1),
(3, 	3,	1),
(3, 	4,	2),
(3, 	5,	2),
(3, 	6,	5),
(3, 	7,	5);
select*from DETALHE_PEDIDO;
-- -------------------------------------------------------------
create table CORREDOR
(
	id_corr int(4) primary key auto_increment,
    nome_corr varchar(15) not null
);
insert into CORREDOR(nome_corr)values
('corredor 1'),
('corredor 2');
select*from CORREDOR;
-- -------------------------------------------------------------
create table COLUNA
(
	id_col int(4) primary key auto_increment,
    nome_col varchar(15) not null,
    id_corr_fk int(4) not null,
    constraint foreign key (id_corr_fk)references CORREDOR(id_corr) ON DELETE CASCADE
);
insert into COLUNA(nome_col, id_corr_fk)values
('coluna 1', '1'),
('coluna 2', '1'),
('coluna 3', '1'),
('coluna 4', '1'),
('coluna 5', '1'),
('coluna 6', '2'),
('coluna 7', '2'),
('coluna 8', '2'),
('coluna 9', '2'),
('coluna 10', '2');
select*from COLUNA;
-- -------------------------------------------------------------
create table PRATELEIRA
(
	id_prat int(4) primary key auto_increment,
    nome_prat varchar(5) not null,
    id_col_fk int(4) not null,
    constraint foreign key (id_col_fk)references COLUNA(id_col) ON DELETE CASCADE
);
insert into PRATELEIRA(nome_prat, id_col_fk)values
('a', '1'),
('b', '1'),
('c', '1'),
('d', '1'),
('a', '2'),
('b', '2'),
('c', '2'),
('d', '2'),
('a', '3'),
('b', '3'),
('c', '3'),
('d', '3'),
('a', '4'),
('b', '4'),
('c', '4'),
('d', '4');
select*from PRATELEIRA;
-- -------------------------------------------------------------
create table ESTADO
(
	id_estado int(4) primary key auto_increment,
    uf varchar(2) not null
);
insert into ESTADO(uf)values('SP');
select*from ESTADO;
-- -------------------------------------------------------------
create table CIDADE
(
	id_cidade int(4) primary key auto_increment,
    nome_cidade varchar(20) not null,
    id_estado_fk int(4) not null,
    constraint foreign key(id_estado_fk)references ESTADO(id_estado) on delete cascade
);
insert into CIDADE(nome_cidade, id_estado_fk)values
('São Paulo', '1'),
('Guarujá', '1'),
('Cotia', '1'),
('Santos', '1'),
('Ribeirão Preto', '1'),
('Campinas', '1');
SELECT*FROM  CIDADE;
-- -------------------------------------------------------------
create table LOGRADOURO
(
	cep varchar(10) primary key,
    nome_logra varchar(50) not null,
    tipo_logra varchar(50) not null,
    id_cidade_fk int(4) not null,
    constraint foreign key(id_cidade_fk)references CIDADE(id_cidade) on delete cascade
);
insert into LOGRADOURO(cep, nome_logra, tipo_logra, id_cidade_fk)values
('06720120', 'Assis Valente', 'rua', '1'),
('06655678', 'dra. Aparecida', 'rua', '6'),
('06666666', 'Epitacio Pessoa', 'avenida', '4'),
('06679876', 'America', 'avenida', '3'),
('06676666', 'Sao Joao', 'rua', '2'),
('08888999', 'da Paz', 'rua', '5');
select*from LOGRADOURO;
-- -------------------------------------------------------------
create table FORN_LOGRA_POSSUI
(
	id_forn_fk int(4) not null,
    cep_fk varchar(10) not null,
    constraint foreign key (id_forn_fk) references FORNECEDOR(id_forn),
    constraint foreign key (cep_fk) references LOGRADOURO(cep)
);
insert into FORN_LOGRA_POSSUI(id_forn_fk, cep_fk)values
('1', '06655678'),
('2', '06666666'),
('3', '06676666'),
('4', '06679876'),
('5', '06720120'),
('6', '08888999');
select*from FORN_LOGRA_POSSUI;
-- -------------------------------------------------------------
create table FORNECEDOR
(
	id_forn int(4) primary key auto_increment,
    nome_forn varchar(30) not null,
    num_end int(6),
    comp_end varchar(4)
);
INSERT INTO FORNECEDOR(nome_forn, num_end, comp_end)values
('Pedrix', 			'25', 	''	),
('Porto Fortaleza', '245', 	''	),
('Pav Max', 		'900', 	'a'	),
('Hidro Max', 		'887', 	''	),
('Constru Mark', 	'12', 	'b'	),
('Fernando EPIs', 	'80', 	''	);
select*from FORNECEDOR;
-- -------------------------------------------------------------
create table EMAIL
(
	id_email_forn int(4) primary key auto_increment,
    email_forn varchar(50) not null,
    id_forn_fk int(4) not null,
    constraint foreign key(id_forn_fk)references FORNECEDOR(id_forn)
);
insert into EMAIL(email_forn, id_forn_fk)values
('contato@pedrix.com.br', '1'),
('porto@gmail.com', '2'),
('pavmax@yahoo.com.br', '3'),
('hidromax@gmail.com', '4'),
('construmark@gmail.com', '5'),
('fernandoepis@gmail.com', '6');
select*from EMAIL;
-- -------------------------------------------------------------
create table TELEFONE
(
	id_tel int(4) primary key auto_increment,
    num_tel varchar(20) not null,
    id_forn_fk int(4) not null,
    constraint foreign key(id_forn_fk)references FORNECEDOR(id_forn)
);
insert into TELEFONE(num_tel, id_forn_fk)values
('3344-4477', '1'),
('3324-4666', '2'),
('3456-7889', '3'),
('3144-0099', '4'),
('3377-8877', '5'),
('2112-4227', '6');
select*from TELEFONE;
-- -------------------------------------------------------------
create table MATERIAL
(
	id_mat int(4) primary key auto_increment,
    nome_mat varchar(50) not null,
    desc_mat varchar(300) not null,
    qtde_estoque int(4) not null,
    id_prat_fk int(4) not null,
    id_forn_fk int(4) not null,
    constraint foreign key(id_prat_fk)references PRATELEIRA(id_prat),
    constraint foreign key(id_forn_fk)references FORNECEDOR(id_forn)
);
INSERT INTO MATERIAL(nome_mat, desc_mat, qtde_estoque, id_prat_fk, id_forn_fk)values
('Tubo PVC', '100mm', '100', '1', '1'),
('Válvula de pressão', '50mm', '100', '2', '1'),
('Braçadeira', '100mm', '90', '3', '2'),
('Cotovelo PVC', '90mm', '50', '4', '2'),
('TE PVC', '100mm', '40', '5', '3'),
('Tubo PVC', '50mm', '80', '6', '3'),
('Tampa de registro', 'Tam. único', '90', '7', '4'),
('Cimento', '50kg', '50', '8', '4'),
('Argamassa', '50kg', '30', '9', '5'),
('Pá', 'Aço inox', '20', '10', '5'),
('Bota bico de aço', 'Tam. 40', '30', '11', '6'),
('Bota bico de aço', 'Tam. 42', '30', '12', '6');
select*from MATERIAL;
-- -------------------------------------------------------------
show tables;




-- Espaço para testes e queries: -------------------------------

-- [Robson] id, status, id_usuario, login dos pedidos fechados 
select 
P.id_pedido 'Cód. Pedido', 
status_pedido 'Status', 
id_usuario_fk 'Cód. Requisitante',
U.login 'Usuário req.'
from PEDIDO AS P inner join USUARIO AS U
on P.id_usuario_fk = U.id_usuario where status_pedido like '%chado%';

-- [Robson] id, status, id_usuario, login dos pedidos abertos
select 
P.id_pedido 'Cód. Pedido', 
status_pedido 'Status', 
id_usuario_fk 'Cód. Requisitante',
U.login 'Usuário req.'
from PEDIDO AS P inner join USUARIO AS U
on P.id_usuario_fk = U.id_usuario where status_pedido like '%berto%';

-- [Robson] Query de detalhe de um pedido específico 
select
D.id_pedido_fk 'Cód. Pedido', 
M.nome_mat 'Nome material', 
D.qtde 'Quantidade', 
D.id_mat_fk  'Cód. material'
from DETALHE_PEDIDO AS D inner join
MATERIAL as M 
on D.id_mat_fk = M.id_mat where D.id_pedido_fk = 1;


-- [Álvaro] Query de relatório de pedido com data de abertura 
select
D.id_pedido_fk 'Cód. Pedido', 
P.data_abertura 'Data de abertura',
M.nome_mat 'Nome material', 
D.qtde 'Quantidade', 
D.id_mat_fk  'Cód. material',
P.id_usuario_fk 'Cód. usuário'
from DETALHE_PEDIDO as D inner join
PEDIDO as P
on D.id_pedido_fk = P.id_pedido inner join
MATERIAL as M
on D.id_mat_fk = M.id_mat where id_pedido_fk = 2;

-- [Robson] Query de relatório de pedido com data de abertura e nome do usuario
select
D.id_pedido_fk 'Cód. Pedido', 
P.data_abertura 'Data de abertura',
M.nome_mat 'Nome material', 
D.qtde 'Quantidade', 
D.id_mat_fk  'Cód. material',
P.id_usuario_fk 'Cód. usuário',
U.login 'Nome usuário'
from DETALHE_PEDIDO as D inner join
PEDIDO as P
on D.id_pedido_fk = P.id_pedido inner join 
USUARIO as U 
on U.id_usuario = P.id_usuario_fk inner join
MATERIAL as M
on D.id_mat_fk = M.id_mat where id_pedido_fk = 6;


/* [Álvaro]Query de relatório de pedidos com status, data de abertura, 
data de fechamento, nome do material, quantidade, cód material, id_usuario e nome do usuario */
select
D.id_pedido_fk 'Cód. Pedido',
P.status_pedido 'Status', 
P.data_abertura 'Data de abertura',
P.data_fechamento 'Data de fechamento',
M.nome_mat 'Nome material', 
D.qtde 'Quantidade', 
D.id_mat_fk  'Cód. material',
P.id_usuario_fk 'Cód. usuário',
U.login 'Nome usuário'
from DETALHE_PEDIDO as D inner join
PEDIDO as P
on D.id_pedido_fk = P.id_pedido inner join 
USUARIO as U 
on U.id_usuario = P.id_usuario_fk inner join
MATERIAL as M
on D.id_mat_fk = M.id_mat where P.id_pedido = 1;

-- [Álvaro] Teste Relatório de endereço de um fornecedor
select
F.nome_forn 'Fornecedor', 
L.tipo_logra 'Tipo', 
L.nome_logra 'Endereço', 
F.num_end 'nº', 
L.cep 'CEP', 
C.nome_cidade 'Cidade', 
E.uf 'Estado'
from FORNECEDOR F inner join
FORN_LOGRA_POSSUI FLP
on F.id_forn = FLP.id_forn_fk inner join
LOGRADOURO L
on FLP.cep_fk = L.cep inner join
CIDADE C
on L.id_cidade_fk = C.id_cidade inner join
ESTADO E
on C.id_estado_fk = E.id_estado where id_forn = 1;


/* Relatório de pedidos em aberto com data de expiração de 7 dias com função date_add,
levando em conta que o prazo estipulado para a expiração seja esse */
select
D.id_pedido_fk 'Pedido',
P.status_pedido 'Status', 
P.data_abertura 'Abertura do pedido',
date_add(P.vencimento, interval 7 day) 'Expiração do pedido',
M.nome_mat 'Nome material', 
D.qtde 'Quantidade', 
D.id_mat_fk  'Cód.material',
P.id_usuario_fk 'Cód.usuário',
U.login 'Nome usuário'
from DETALHE_PEDIDO as D inner join
PEDIDO as P
on D.id_pedido_fk = P.id_pedido inner join 
USUARIO as U 
on U.id_usuario = P.id_usuario_fk inner join
MATERIAL as M
on D.id_mat_fk = M.id_mat where P.status_pedido like '%erto%';