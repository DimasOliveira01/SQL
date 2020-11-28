-- Agora vamos elaborar o Modelo Físico do Banco de Dados!

-- Para não provocar erros na criação do Banco de Dados, temos que executar uma ação de cada vez, deixando o cursor
-- no final de cada declaração e clicando no botão "Execute the statement under the Keyboard cursor"

-- Criando o banco de dados CAC:

CREATE DATABASE CAC
default character set Latin1 
default collate latin1_general_ci;	-- define o padrão mais utilizado no Brasil

-- Fontes: https://dev.mysql.com/doc/refman/5.7/en/charset-applications.html
-- https://ajuda.locaweb.com.br/wiki/resolver-caracteres-acentuados-no-mysql/

-- Disponibilizando o banco de dados CAC para uso

USE CAC;

-- Criando as tabelas do projeto

CREATE TABLE DEPARTAMENTO (
id_dpto VARCHAR(10),
nome_dpto VARCHAR(50),
sigla_dpto VARCHAR(10),
coordena_dpto VARCHAR(10) NULL,
primary key (id_dpto)
) DEFAULT charset = Latin1;

CREATE TABLE SUBAREA (
id_subarea VARCHAR(10),
nome_subarea VARCHAR(50),
sigla_subarea VARCHAR(10),
id_dpto VARCHAR(10),
coordena_subarea VARCHAR(10) NULL,
PRIMARY KEY(id_subarea),
FOREIGN KEY(id_dpto) REFERENCES DEPARTAMENTO (id_dpto)
) DEFAULT charset = Latin1;

CREATE TABLE CURSO (
codigo_curso VARCHAR(10),
nome_curso VARCHAR(50),
nivel_curso VARCHAR(50),
id_subarea VARCHAR(10),
coordena_curso VARCHAR(10) NULL,
primary key (codigo_curso),
FOREIGN KEY(id_subarea) REFERENCES SUBAREA(id_subarea)
) DEFAULT charset = Latin1;

CREATE TABLE DISCIPLINA (
codigo_disc VARCHAR(10),
nome_disc VARCHAR(50),
carga_horaria DECIMAL(10),
período INTEGER, 
optativa ENUM ('S', 'N'),
codigo_curso VARCHAR(10),
PRIMARY KEY(codigo_disc),
FOREIGN KEY(codigo_curso) REFERENCES CURSO (codigo_curso)
) DEFAULT charset = Latin1;

CREATE TABLE DOCENTE (
matricula VARCHAR(10),
nome_doc VARCHAR(50),
data_nasc DATE,
data_admissao DATE,
email VARCHAR(50),
id_subarea VARCHAR(10),
PRIMARY KEY(matricula),
FOREIGN KEY(id_subarea) REFERENCES SUBAREA(id_subarea)
) DEFAULT charset = Latin1;

CREATE TABLE TELEFONE_DOCENTE (
matricula VARCHAR(10),
num_telefone VARCHAR(11),
PRIMARY KEY(matricula,num_telefone),
FOREIGN KEY(matricula) REFERENCES DOCENTE(matricula)
) DEFAULT charset = Latin1;

CREATE TABLE ALUNO (
prontuario VARCHAR(10),
nome_aluno VARCHAR(50),
email VARCHAR(50),
RG VARCHAR(9),
CPF VARCHAR(11),
codigo_curso VARCHAR(10),
PRIMARY KEY(prontuario),
FOREIGN KEY(codigo_curso) REFERENCES CURSO(codigo_curso)
) DEFAULT charset = Latin1;

CREATE TABLE TELEFONE_ALUNO (
prontuario VARCHAR(10),
num_telefone VARCHAR(11),
PRIMARY KEY(prontuario,num_telefone),
FOREIGN KEY(prontuario) REFERENCES ALUNO(prontuario)
) DEFAULT charset = Latin1;

CREATE TABLE PROJETO (
id_projeto VARCHAR(10),
nome_projeto VARCHAR(50),
status_projeto VARCHAR(10),
id_dpto VARCHAR(10),
PRIMARY KEY (id_projeto),
FOREIGN KEY(id_dpto) REFERENCES DEPARTAMENTO(id_dpto)
) DEFAULT charset = Latin1;

CREATE TABLE PROPOE_DOC_PROJ (
matricula VARCHAR(10),
id_projeto VARCHAR(10),
PRIMARY KEY(matricula, id_projeto),
FOREIGN KEY(matricula) REFERENCES DOCENTE(matricula),
FOREIGN KEY(id_projeto) REFERENCES PROJETO(id_projeto)
) DEFAULT charset = Latin1;

CREATE TABLE REALIZOU_ALU_DISC (
prontuario VARCHAR(10),
codigo_disc VARCHAR(10),
PRIMARY KEY(prontuario,codigo_disc),
FOREIGN KEY(prontuario) REFERENCES ALUNO(prontuario),
FOREIGN KEY(codigo_disc) REFERENCES DISCIPLINA(codigo_disc)
) DEFAULT charset = Latin1;

CREATE TABLE CURSA_ALU_DISC (
prontuario VARCHAR(10),
codigo_disc VARCHAR(10),
PRIMARY KEY(prontuario,codigo_disc),
FOREIGN KEY(prontuario) REFERENCES ALUNO(prontuario),
FOREIGN KEY(codigo_disc) REFERENCES DISCIPLINA(codigo_disc)
) DEFAULT charset = Latin1;

-- Algumas alterações somente são possíveis após a criação de outra tabela, por exemplo somente podemos colocar a FOREIGN KEY(matricula), da tabela DOCENTE, na tabela DISCIPLINA, após a criação desta última tabela. Desta forma utilizamos o comando ALTER TABLE.

ALTER TABLE DISCIPLINA ADD matricula VARCHAR(10), ADD FOREIGN KEY(matricula) REFERENCES DOCENTE(matricula);
ALTER TABLE DISCIPLINA ADD id_projeto VARCHAR(10), ADD FOREIGN KEY(id_projeto) REFERENCES PROJETO (id_projeto);
ALTER TABLE ALUNO ADD id_projeto VARCHAR(10), ADD FOREIGN KEY (id_projeto) REFERENCES PROJETO (id_projeto);
ALTER TABLE DEPARTAMENTO ADD FOREIGN KEY(coordena_dpto) REFERENCES DOCENTE(matricula);
ALTER TABLE SUBAREA ADD FOREIGN KEY(coordena_subarea) REFERENCES DOCENTE(matricula);
ALTER TABLE CURSO ADD FOREIGN KEY(coordena_curso) REFERENCES DOCENTE(matricula);

-- Incluindo dados nas tabelas do Banco de Dados do CAC

-- Incluindo dados na tabela DEPARTAMENTO

INSERT INTO DEPARTAMENTO VALUES
('1', 'Departamento de Construção Civil','DCC', NULL),
('2', 'Departamento de Ciências e Matemática','DCM', NULL),
('3', 'Departamento de Elétrica','DEL', NULL),
('4', 'Departamento de Humanidades','DHU', NULL),
('5', 'Departamento de Informática e Turismo','DIT', NULL),
('6', 'Departamento de Mecânica','DME', NULL);

-- Incluindo dados na tabela SUBAREA

INSERT INTO SUBAREA VALUES
('1', 'Subárea de Construção Civil', 'SCC', '1', NULL),
('2', 'Subárea de Biologia', 'SAB', '2', NULL),
('3', 'Subárea de Física', 'SAF', '2', NULL),
('4', 'Subárea de Matemática', 'SAM', '2', NULL),
('5', 'Subárea de Química', 'SAQ', '2', NULL),
('6', 'Subárea de Automação Industrial', 'SAI', '3', NULL),
('7', 'Subárea de Eletrotécnica', 'SEL', '3', NULL),
('8', 'Subárea de Eletrônica', 'SEO', '3', NULL),
('9', 'Subárea de Telecomunicações', 'STC', '3', NULL),
('10', 'Subárea de Códigos e Linguagens', 'SCL', '4', NULL),
('11', 'Subárea de Sociedade e Cultura', 'SSC', '4', NULL),
('12', 'Subárea de Cursos de Informática', 'SCI', '5', NULL),
('13', 'Subárea de Turismo e Hospitalidade', 'STH', '5', NULL),
('14', 'Subárea de Mecânica', 'SME', '6', NULL);

-- Incluindo dados na tabela CURSO - cursos pertencentes ao DIT

INSERT INTO CURSO VALUES
('852', 'TEC. EM ANÁLISE E DESENVOLVIMENTO DE SISTEMAS', 'Superior', '12', NULL),
('628', 'TECNOLOGIA EM TURISMO E HOSPITALIDADE', 'Superior', '13', NULL),
('638', 'TÉCNICO EM INFORMÁTICA INTEGRADO AO ENSINO MÉDIO', 'Médio', '12', NULL),
('609', 'TÉCNICO EM QUALIDADE INTEGRADO AO ENSINO MÉDIO', 'Medio', '11', NULL),
('610', 'TÉCNICO MECÂNICA INTEGRADO AO ENSINO MÉDIO', 'Medio', '14', NULL),
('611', 'TÉCNICO ELETROTÉCNICA INTEGRADO AO ENSINO MÉDIO', 'Medio', '7', NULL),
('629', 'TÉCNICO ELETRÔNICA INTEGRADO AO ENSINO MÉDIO', 'Medio', '8', NULL),
('497', 'TECNOLOGIA EM SISTEMAS ELETRÔNICOS', 'Superior', '8', NULL),
('549', 'FORMAÇÃO DOC. EDUCAÇÃO PROFISSIONAL NÍVEL MÉDIO ', 'Superior', '11', NULL),
('551', 'LICENCIATURA EM LETRAS', 'Superior', '10', NULL),
('559', 'TECNOLOGIA EM PROCESSOS GERENCIAIS', 'Superior', '11', NULL),
('563', 'TECNOLOGIA EM GESTÃO DA PRODUÇÃO INDUSTRIAL', 'Superior', '6', NULL),
('565', 'ENGENHARIA CIVIL', 'Superior', '1', NULL),
('566', 'ENGENHARIA DE CONTROLE E AUTOMAÇÃO', 'Superior', '6', NULL),
('569', 'LICENCIATURA EM GEOGRAFIA', 'Superior', '11', NULL),
('581', 'TECNOLOGIA EM SISTEMAS ELÉTRICOS', 'Superior', '7', NULL),
('596', 'LICENCIATURA EM CIÊNCIAS BIOLÓGICAS', 'Superior', '2', NULL),
('600', 'TEC. EM ANÁLISE E DESENVOLVIMENTO DE SISTEMAS', 'Superior', '12', NULL),
('603', 'ENGENHARIA DE PRODUÇÃO', 'Superior', '6', NULL),
('604', 'LICENCIATURA EM MATEMÁTICA', 'Superior', '4', NULL),
('605', 'PROGRAMA FORMAÇÃO DOCENTES EDUCAÇÃO BÁSICA', 'Superior', '11', NULL),
('612', 'ENGENHARIA ELETRÔNICA', 'Superior', '8', NULL),
('624', 'LICENCIATURA EM FÍSICA', 'Superior', '3', NULL),
('626', 'TECNOLOGIA EM AUTOMAÇÃO INDUSTRIAL', 'Superior', '6', NULL),
('730', 'LICENCIATURA EM QUÍMICA', 'Superior', '5', NULL),
('732', 'ARQUITETURA E URBANISMO', 'Superior', '11', NULL),
('865', 'ENGENHARIA MECÂNICA', 'Superior', '6', NULL),
('946', 'ENGENHARIA ELÉTRICA', 'Superior', '7', NULL);

-- Incluindo dados na tabela DOCENTE

INSERT INTO DOCENTE VALUES
('3150749', 'Aldo Marcelo Paim', '1970-05-25', '2000-01-20', 'aldo.paim@ifsp.edu.br', '12'),
('2680331', 'Alexandre Beletti Ferreira', '1980-01-03', '2014-02-02', 'higuita@ifsp.edu.br', '12'),
('1753846', 'Andre Evandro Lourenco', '1975-01-03', '2011-02-15', 'andreevandro@ifsp.edu.br', '12'),
('2517425', 'Eurides Balbino da Silva', '1974-06-05', '2007-02-15', 'eubalbino@ifsp.edu.br', '12'),
('2297124', 'Paulo Roberto de Abreu', '1969-12-10', '2001-02-15', 'prabreu@ifsp.edu.br', '12'),
('2157872', 'Marcos Hideyuki Yokoyama', '1960-11-23', '2016-02-15', 'marcoshy@ifsp.edu.br', '13'),
('1350141', 'Andre Luiz da Silva', '1970-05-25', '2000-01-20', 'andrels@ifsp.edu.br', '12'),
('2782934', 'Antonio Airton Palladino', '1970-05-25', '2000-01-20', 'antonio.palladino@ifsp.edu.br', '12'),
('3864404', 'Antonio Ferreira Viana', '1970-05-25', '2000-01-20', 'antonio.viana@ifsp.edu.br', '12'),
('278356', 'Cesar Lopes Fernandes', '1970-05-25', '2000-01-20', 'cesar.lf@ifsp.edu.br', '12'),
('2357579', 'Claudete de Oliveira Alves', '1970-05-25', '2000-01-20', 'claudete.oa@ifsp.edu.br', '12'),
('2306499', 'Claudia Miyuki Werhmuller', '1970-05-25', '2000-01-20', 'claudiay@ifsp.edu.br', '12'),
('2325256', 'Daniel Marques Gomes de Morais', '1970-05-25', '2000-01-20', 'daniel.morais@ifsp.edu.br', '12'),
('2445922', 'Domingos Bernardo Gomes Santos', '1970-05-25', '2000-01-20', 'bernardo@ifsp.edu.br', '12'),
('2144297', 'Domingos Lucas Latorre de Oliveira', '1970-05-25', '2000-01-20', 'domingos.oliveira@ifsp.edu.br', '12'),
('278343', 'Francisco Verissimo Luciano', '1970-05-25', '2000-01-20', 'fvluciano@ifsp.edu.br', '12'),
('1552863', 'Ivan Francolin Martinez', '1970-05-25', '2000-01-20', 'ivanfm@ifsp.edu.br', '12'),
('1558691', 'Joao Vianei Tamanini', '1970-05-25', '2000-01-20', 'joao.vt@ifsp.edu.br', '12'),
('1977085', 'Josceli Maria Tenorio', '1970-05-25', '2000-01-20', 'josceli.tenorio@ifsp.edu.br', '12'),
('1569520', 'Jose Braz de Araujo', '1970-05-25', '2000-01-20', 'jose.ba@ifsp.edu.br', '12'),
('1566753', 'Jose Oscar Machado Alexandre', '1970-05-25', '2000-01-20', 'oscar@ifsp.edu.br', '12'),
('1146598', 'Leandro Pinto Santana', '1970-05-25', '2000-01-20', 'leandro.santana@ifsp.edu.br', '12'),
('1284708', 'Leonardo Andrade Motta de Lima', '1970-05-25', '2000-01-20', 'leonardo.motta@ifsp.edu.br', '12'),
('2223376', 'Leonardo Bertholdo', '1970-05-25', '2000-01-20', 'l.bertholdo@ifsp.edu.br', '12'),
('1085700', 'Luis Fernando Aires Branco Menegueti', '1970-05-25', '2000-01-20', 'aires@ifsp.edu.br', '12'),
('2425017', 'Luk Cho Man', '1970-05-25', '2000-01-20', 'luk@ifsp.edu.br', '12'),
('2223246', 'Marcelo Tavares de Santana', '1970-05-25', '2000-01-20', 'marcelo.tavares@ifsp.edu.br', '12'),
('1823628', 'Miguel Angelo Tancredi Molina', '1970-05-25', '2000-01-20', 'miguel.molina@ifsp.edu.br', '12'),
('1655022', 'Rodrigo Ribeiro de Oliveira', '1970-05-25', '2000-01-20', 'rodrigo.oliveira@ifsp.edu.br', '12'),
('1037319', 'Vladimir Camelo Pinto', '1970-05-25', '2000-01-20', 'vladimir.camelo@ifsp.edu.br', '12'),
('2318041', 'Wagner de Paula Gomes', '1970-05-25', '2000-01-20', 'wagner.gomes@ifsp.edu.br', '12'),
('1521170', 'Brenno Vitorino Costa', '1985-05-25', '2015-01-20', 'brenno@ifsp.edu.br', '13'),
('1846877', 'Camila Collpy Gonzalez Fernandez', '1985-05-25', '2015-01-20', 'camilacollpy@ifsp.edu.br', '13'),
('2154904', 'Catherine Cavalcanti Margoni', '1985-05-25', '2015-01-20', 'catherine.margoni@ifsp.edu.br', '13'),
('3060118', 'Dennis Minoru Fujita', '1985-05-25', '2015-01-20', 'dennis.fujita@ifsp.edu.br', '13'),
('2619037', 'Erika Sayuri Koga Di Napoli', '1985-05-25', '2015-01-20', 'kogadinapoli@ifsp.edu.br', '13'),
('2684488', 'Fernanda Pereira Liguori', '1985-05-25', '2015-01-20', 'fernandaliguori@ifsp.edu.br', '13'),
('2512202', 'Georgia Nicoletti Garcia', '1985-05-25', '2015-01-20', 'georgia.garcia@ifsp.edu.br', '13'),
('2684523', 'Leandro Rodrigues Gonzalez Fernandez', '1985-05-25', '2015-01-20', 'legonzalez@ifsp.edu.br', '13'),
('2487454', 'Leonardo Nogueira de Moraes', '1985-05-25', '2015-01-20', 'lndmoraes@ifsp.edu.br', '13'),
('2976053', 'Marina Monteiro da Silva', '1985-05-25', '2015-01-20', 'marina.monteiro@ifsp.edu.br', '13'),
('1545919', 'Rafael Chequer Bauer', '1985-05-25', '2015-01-20', 'rafaelbauer@ifsp.edu.br', '13'),
('2619022', 'Rafaela Camara Malerba', '1985-05-25', '2015-01-20', 'rafaela@ifsp.edu.br', '13'),
('1370486', 'Raul Jose de Souza', '1985-05-25', '2015-01-20', 'raul.js@ifsp.edu.br', '13'),
('1682662', 'Rodrigo de Benedictis Delphino', '1985-05-25', '2015-01-20', 'rodrigo.delphino@ifsp.edu.br', '13'),
('3087212', 'Simone Monteiro Cardoso', '1985-05-25', '2015-01-20', 'simone.cardoso@ifsp.edu.br', '13'),
('3045641', 'Tiago Juliano', '1985-05-25', '2015-01-20', 'tiago.juliano@ifsp.edu.br', '13');

-- Incluindo dados na tabela TELEFONE_DOCENTE

INSERT INTO TELEFONE_DOCENTE VALUES
('3150749', '1127637525'),
('3150749', '1127637515'),
('3150749', '1127637521'),
('2680331', '1127637625'),
('2680331', '1127637525'),
('1753846', '1127637525'),
('2517425', '1127637525'),
('2297124', '1127637525'),
('2157872', '1127637521'),
('2157872', '1127637646'),
('1350141', '1127637525'),
('2782934', '1137754583'),
('3864404', '1127637525'),
('278356', '1127637525,'),
('278356', '1127637515,'),
('278356', '1127637521'),
('2357579', '1127637525'),
('2306499', '1127637525'),
('2306499', '1127637515'),
('2306499', '1127637521'),
('2325256', '1127637525'),
('2445922', '1127637525'),
('2144297', '1127637525'),
('278343', '1127637525'),
('1552863', '1127637525'),
('1558691', '1127637525'),
('1977085', '1127637525'),
('1569520', '1127637525'),
('1566753', '1127637525'),
('1146598', '1127637525'),
('1284708', '1127637525'),
('1284708', '1127637515'),
('1284708', '1127637521'),
('2223376', '1127637525'),
('1085700', '1127637525'),
('2425017', '1127637525'),
('2223246', '1127637525'),
('1823628', '1127637525'),
('1655022', '1127637525'),
('1037319', '1127637525'),
('1037319', '1127637515'),
('1037319', '1127637521'),
('2318041', '1127637525'),
('2318041', '1127637515'),
('2318041', '1127637521'),
('1521170', '1127637646'),
('1846877', '1127637646'),
('2154904', '1127637646'),
('3060118', '1127637646'),
('2619037', '1127637646'),
('2684488', '1127637646'),
('2512202', '1127637646'),
('2684523', '1127637646'),
('2487454', '1127637646'),
('2976053', '1127637646'),
('1545919', '1127637646'),
('2619022', '1127637646'),
('1370486', '1127637646'),
('1682662', '1127637577'),
('1682662', '1127637520'),
('3087212', '1127637646'),
('3045641', '1127637646');

-- Incluindo dados na tabela PROJETO

INSERT INTO PROJETO VALUES
('1', 'Suporte às Disciplinas de Desenvolvimento Web', 'APROVADO', '5'),
('2', 'Suporte às Disciplinas de Engenharia de Software', 'APROVADO', '5'),
('3', 'Suporte às Disciplinas de Linguagem de Programação', 'APROVADO', '5'),
('4', 'Suporte às Disciplinas de Projetos', 'APROVADO', '5'),
('5', 'Suporte às Disciplinas de Banco de Dados', 'APROVADO', '5');

-- Incluindo dados na tabela PROPOE_DOC_PROJ 

INSERT INTO PROPOE_DOC_PROJ VALUES
('3150749', '4'),
('2680331', '2'),
('1977085', '1'),
('2517425', '5'),
('2223376', '3');

-- Incluindo dados na tabela ALUNO, depois iremos fazer um script para criar 1000 cadastros automaticamente 

INSERT INTO ALUNO VALUES
('SP3026591', 'LEANDRO SAMPAIO PEREIRA', 'leandro@gmail.com', '465348764', '25463164834', '852', NULL),
('SP3026582', 'LETICIA BRITO DOS SANTOS', 'leticia@gmail.com', '995348712', '58463164057', '852', NULL),
('SP3024148', 'BRUNNO PAPIS GUSMAO', 'brunno@gmail.com', '248976758', '84682347819', '852', NULL),
('SP3021734', 'RAFAEL DOS SANTOS FERREIRA', 'rafael@gmail.com', '348976335', '11115579864', '852', NULL),
('SP302427X', 'CAMILA LOPEZ FRANQUEIRA DE FRANCA', 'camila@gmail.com', '864579631', '25794631155', '852', NULL),
('SP302170X', 'GAWAN AUGUSTO GOMES FERREIRA', 'gawan@gmail.com', '16464645', '6566555', '852', '1'),
('SP3024156', 'RENAN COELHO SANTOS', 'renan@gmail.com', '6584846', '1321456', '852', NULL),
('SP3022552', 'CEZAR AUGUSTO DE NORONHA NAJJARIAN BATISTA', 'cezar@gmail.com', '98794651', '149879', '852', NULL),
('SP3023109', 'LUIS FERNANDO ROCA KILZER', 'luis@gmail.com', '955161', '1324616', '852', NULL),
('SP3023176', 'PEDRO HENRIQUE SILVA DOS SANTOS', 'pedro@gmail.com', '8156984', '3165245', '852', NULL),
('SP3023184', 'FABIO MENDES TORRES', 'fabio@gmail.com', '65984899', '511188', '852', NULL),
('SP3023231', 'ADRIANO RASPANTE SUARES', 'adriano@gmail.com', '9819656', '288496', '852', NULL),
('SP3024202', 'LARISSA GUILGER DE PROENCA', 'larissa@gmail.com', '51465616', '981651', '852', NULL),
('SP3024253', 'LINEKER EVANGELISTA DA SILVA', 'lineker@gmail.com', '849849', '985166', '852', NULL),
('SP3024296', 'GUSTAVO DA COSTA SOUZA SILVA', 'gustavo@gmail.com', '1619846', '468562', '852', NULL),
('SP3024792', 'MARIVALDO TORRES JUNIOR', 'marivaldo@gmail.com', '7416365', '668546', '852', NULL),
('SP3026868', 'GABRIELA VIANA BILINSKI', 'gabriela@gmail.com', '5761226', '165636', '852', '2'),
('SP3030571', 'CAROLINA DE MORAES JOSEPHIK', 'carolina@gmail.com', '1949156', '896989', '852', NULL),
('SP3030598', 'DIMAS DE OLIVEIRA', 'dimas@gmail.com', '6548998', '19819165', '852', '5'),
('SP3030644', 'JOAO VICTOR TEIXEIRA DE OLIVEIRA', 'joao@gmail.com', '9856165', '1996561', '852', NULL),
('SP3030661', 'LUCAS AMBROZIN GALLO', 'lucas@gmail.com', '8946516', '34983664', '852', NULL),
('SP3030679', 'MARIANA DA SILVA ZANGROSSI', 'mariana@gmail.com', '54665498', '3356498', '852', NULL),
('SP3030687', 'MATHEUS AUGUSTO DO NASCIMENTO DIAS', 'matheus@gmail.com', '19891656', '5666866', '852', NULL),
('SP3031853', 'BRUNA RODRIGUES DE OLIVEIRA', 'bruna@gmail.com', '19498949', '99489466', '852', '3'),
('SP3032337', 'JULIANA MACEDO SANTIAGO', 'juliana@gmail.com', '1984989', '31564666', '852', NULL),
('SP303240X', 'EDUARDO VIVI DE ARAUJO', 'eduardo@gmail.com', '8498998', '9846516', '852', NULL),
('SP890534', 'CESAR LOPES FERNANDES', 'cesar@gmail.com', '498498', '126489', '852', '4');

-- Incluindo dados na tabela TELEFONE_ALUNO

INSERT INTO TELEFONE_ALUNO VALUES
('SP3026591', '1156984563'),
('SP3026582', '1156984563'),
('SP3024148', '1134584945'),
('SP3021734', '1156325489'),
('SP302427X', '1189898954');


-- Incluindo dados na tabela DISCIPLINA - do curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas

INSERT INTO DISCIPLINA VALUES
('ADEA1', 'Administração de Empresas', 57, 1, 'N', '852', '1655022', NULL),
('ES1A1', 'Engenharia de Software I', 57, 1, 'N', '852', '2325256', '2'),
('LG1A1', 'Lógica de Programação I', 95, 1, 'N', '852', '2517425', NULL),
('MATA1', 'Matemática para Informática', 95, 1, 'N', '852', '1558691', NULL),
('OACA1', 'Organização e Arquitetura de Computadores', 57, 1, 'N', '852', '1569520', NULL),
('PTAA1', 'Produção de Textos Acadêmico-Profissionais', 38, 1, 'N', '852', '2306499', NULL),
('RHUA1', 'Recursos Humanos em Tecnologia da Informação', 38, 1, 'N', '852', '1037319', NULL),
('BD1A2', 'Banco de Dados I', 95, 2, 'N', '852', '2517425', '1'),
('PFDA1', 'Práticas e Ferramentas Desenvolvimento Software', '38', '1', 'N', '852', '2445922', NULL),
('ES2A2', 'Engenharia de Software II', '95', '2', 'N', '852', '1146598', '2'),
('EDDA2', 'Estrutura de Dados', '95', '2', 'N', '852', '2517425', NULL),
('LG2A2', 'Lógica de Programação II', '95', '2', 'N', '852', '2223376', NULL),
('SOPA2', 'Sistemas Operacionais', '95', '2', 'N', '852', '2680331', NULL),
('BD2A3', 'Banco de Dados II', '95', '3', 'N', '852', '2517425', '1'),
('DW1A3', 'Desenvolvimento Web I', '57', '3', 'N', '852', '1977085', '5'),
('EMPA3', 'Empreendedorismo', '38', '3', 'N', '852', '1655022', NULL),
('ES3A3', 'Engenharia de Software III', '95', '3', 'N', '852', '2144297', '2'),
('LP1A3', 'Linguagem de Programação I', '95', '3', 'N', '852', '2223376', '3'),
('REDA3', 'Redes de Computadores', '95', '3', 'N', '852', '2680331', NULL),
('DW2A4', 'Desenvolvimento Web II', '95', '4', 'N', '852', '1977085', '5'),
('ES4A4', 'Engenharia de Software IV', '95', '4', 'N', '852', '2144297', '2'),
('GPRA4', 'Gestão de Projetos', '38', '4', 'N', '852', '1569520', NULL),
('LP2A4', 'Linguagem de Programação II', '95', '4', 'N', '852', '2357579', '3'),
('SEGA4', 'Segurança da Informação', '57', '4', 'N', '852', '3150749', NULL),
('SESA4', 'Serviços e Servidores de Rede', '95', '4', 'N', '852', '2680331', NULL),
('ESPA5', 'Estatística e Probabilidade', '57', '5', 'N', '852', '1558691', NULL),
('LP3A5', 'Linguagem de Programação III', '95', '5', 'N', '852', '278343', '3'),
('MPNA5', 'Modelagem de Processos de Negócios', '38', '5', 'N', '852', '1655022', NULL),
('PDWA5', 'Programação Dinâmica para Web', '57', '5', 'N', '852', '1977085', '5'),
('PI1A5', 'Projeto Integrado I ', '95', '5', 'N', '852', '2318041', '4'),
('SIDA5', 'Sistemas Distribuídos', '95', '5', 'N', '852', '1037319', NULL),
('GTIA6', 'Gestão e Governança da Tecnologia da Informação', '57', '6', 'N', '852', '1085700', NULL),
('ICDA6', 'Introdução a Ciência de Dados', '95', '6', 'N', '852', '2517425', '1'),
('I0CA6', 'Introdução à Otimização Combinatória', '57', '6', 'N', '852', '1558691', NULL),
('LESA6', 'Laboratório de Escalabilidade de Sistemas', '38', '6', 'N', '852', '1569520', NULL),
('PI2A6', 'Projeto Integrado II', '95', '6', 'N', '852', '1566753', '4'),
('LIBA7', 'LIBRAS', '38', NULL, 'S', '852', '1284708', NULL);

-- vamos executar o primeiro select para ver uma das tabelas:

select * from projeto;

-- Incluindo dados na tabela REALIZOU_ALU_DISC 

INSERT INTO REALIZOU_ALU_DISC VALUES
('SP3026591', 'LG1A1'),
('SP3026582', 'BD1A2'),
('SP3024148', 'ES1A1'),
('SP3021734', 'LG1A1'),
('SP302427X', 'BD1A2');

-- Incluindo dados na tabela CURSA_ALU_DISC 

INSERT INTO CURSA_ALU_DISC VALUES
('SP3026591', 'MATA1'),
('SP3026582', 'OACA1'),
('SP3024148', 'ADEA1'),
('SP3021734', 'RHUA1'),
('SP302427X', 'ADEA1');

-- Agora vamos consultar algumas tabelas adicionadas

SELECT * FROM DOCENTE;
SELECT * FROM ALUNO;

-- Agora que incluímos os dados nas tabelas, poderemos completar algumas tabelas que não foram populadas por completo.
-- Por exemplo na tabela CURSO faltou adicionar o coordenador do curso adicionado nas tabelas, desta forma utilizaremos 
-- o comando UPDATE. Com o comando UPDATE também conseguimos atualizar os dados de uma tabela.

UPDATE CURSO SET coordena_curso = '2680331' WHERE codigo_curso = '852';
UPDATE CURSO SET coordena_curso = '2157872' WHERE codigo_curso = '628';
UPDATE CURSO SET coordena_curso = '2297124' WHERE codigo_curso = '638';
UPDATE CURSO SET coordena_curso = '2680331' WHERE codigo_curso = '638';

-- agora vamos atualizar quais professores são coordenadores do departamento

update departamento set coordena_dpto = '3150749' where id_dpto = '1';
update departamento set coordena_dpto = '2680331' where id_dpto = '2';
update departamento set coordena_dpto = '1753846' where id_dpto = '3';
update departamento set coordena_dpto = '2517425' where id_dpto = '4';
update departamento set coordena_dpto = '2297124' where id_dpto = '5';
update departamento set coordena_dpto = '2157872' where id_dpto = '6';

-- agora vamos atualizar quais professores coordenam as subareas
update subarea set coordena_subarea = '1350141' where id_subarea = '1';
update subarea set coordena_subarea = '2782934' where id_subarea = '2';
update subarea set coordena_subarea = '3864404' where id_subarea = '3';
update subarea set coordena_subarea = '278356' where id_subarea = '4';
update subarea set coordena_subarea = '2357579' where id_subarea = '5';
update subarea set coordena_subarea = '2306499' where id_subarea = '6';
update subarea set coordena_subarea = '2325256' where id_subarea = '7';
update subarea set coordena_subarea = '2445922' where id_subarea = '8';
update subarea set coordena_subarea = '2144297' where id_subarea = '9';
update subarea set coordena_subarea = '278343' where id_subarea = '10';
update subarea set coordena_subarea = '1552863' where id_subarea = '11';
update subarea set coordena_subarea = '1558691' where id_subarea = '12';
update subarea set coordena_subarea = '3087212' where id_subarea = '13';
update subarea set coordena_subarea = '3045641' where id_subarea = '14';


-- Agora vamos consultar novamente algumas tabelas adicionadas

SELECT * FROM DOCENTE;
SELECT * FROM CURSO;
SELECT * FROM DEPARTAMENTO;
SELECT * FROM ALUNO WHERE nome_aluno = 'BRUNNO PAPIS GUSMAO';
SELECT email FROM ALUNO WHERE nome_aluno = 'BRUNNO PAPIS GUSMAO';

-- Agora vamos alterar o nome de um aluno:

-- mas antes vamos verificar o nome deste aluno:
SELECT nome_aluno FROM ALUNO WHERE prontuario = 'SP302427X';
-- agora podemos realizar o update do aluno:
UPDATE ALUNO SET nome_aluno = 'CAMILA LOPEZ FRANQUEIRA' WHERE prontuario = 'SP302427X';
-- vamos verificar se a mudança realmente ocorreu?
SELECT nome_aluno FROM ALUNO WHERE prontuario = 'SP302427X';


-- Agora vamos alterar o e-mail do aluno Brunno Papis Gusmao.

-- Para realizar atualizações no mySQL somente é permitido realizar atualizações apresentando a PRIMARY KEY. Embora seja 
-- possível alterar a configuração do MySQL para alterar deste modo, a forma correta(pois somente alteramos pela PRIMARY KEY) é da forma apresentada no código seguinte.
-- Desta forma, vamos realizar a alteração de forma correta, através da Primary Key, a qual é única. Fonte: https://dev.mysql.com/doc/refman/8.0/en/update.html
 -- Mas antes vamos verificar o e-mail do aluno:
 SELECT email FROM ALUNO WHERE nome_aluno = 'BRUNNO PAPIS GUSMAO';
 UPDATE ALUNO, (SELECT prontuario FROM ALUNO WHERE nome_aluno = 'Brunno Papis Gusmao') AS selecao 
 SET email = 'brunnopapis@gmail.com' WHERE ALUNO.prontuario = selecao.prontuario;
-- Agora vamos verificar se o update ocorreu:
SELECT email FROM ALUNO WHERE nome_aluno = 'BRUNNO PAPIS GUSMAO';

-- Agora vamos inserir um novo aluno para posteriormente apagar esta linha

INSERT INTO ALUNO (prontuario, nome_aluno, email, RG, CPF, codigo_curso, id_projeto) VALUES
('SP3030596', 'Mario da Silva', 'mario@gmail.com', '846785458', '58762314559', '852', NULL);
-- vamos realizar um SELECT para verificar se o aluno foi incluído no Banco de Dados
SELECT * FROM ALUNO WHERE prontuario = 'SP3030596';
-- agora vamos deletar o aluno que acabou de ser inserido:
DELETE FROM ALUNO WHERE prontuario = 'SP3030596';
-- se verificarmos agora o aluno não está mais no banco:
SELECT * FROM ALUNO WHERE prontuario = 'SP3030596';

-- vamos inserir 1000 alunos na tabela ALUNO, em mySQL é necessário criar um PROCEDURE para utilizar o comando WHILE 
DELIMITER $$
CREATE PROCEDURE PreencheAluno(nome VARCHAR(10))
BEGIN
    DECLARE contador INT default 1;
    WHILE contador <= 1000 DO
        INSERT INTO ALUNO VALUES (contador, nome, 'maria@gmail.com', '2342545', '9896313', '852', NULL);
        SET contador = contador + 1;
    END WHILE;
END$$
DELIMITER ;
-- Após criar esta PROCEDURE é necessário chamá-la através do comando CALL
CALL PreencheAluno('maria');
-- Após chamar o PROCEDURE PreencheAluno você pode dar um SELECT e verificar que os 1000 alunos foram inseridos na tabela ALUNO

SELECT * FROM ALUNO ORDER BY nome_aluno;

-- Agora vamos fazer umas consultas um pouco mais difíceis:

-- Quais os professores, com respectivas áreas e departamentos que apresentaram projetos e quais os nomes desses projetos.
-- Esta forma de pesquisa é mais antiga, mas pode ser encontrada em Banco de Dados mais antigos 
SELECT a.nome_doc AS Nome_professor, b.nome_subarea AS Subarea, c.nome_dpto AS Nome_departamento, d.nome_projeto AS Projeto
FROM docente AS a, subarea AS b, departamento AS c, projeto AS d, propoe_doc_proj AS e
WHERE d.id_dpto = c.id_dpto AND a.id_subarea = b.id_subarea AND e.id_projeto = d.id_projeto AND e.matricula = a.matricula;
-- Atualmente as pesquisas são realizadas desta forma, com os JOINs:
SELECT a.nome_doc AS Nome_professor, b.nome_subarea AS Subarea, c.nome_dpto AS Nome_departamento, e.nome_projeto AS Projeto
FROM docente AS a INNER JOIN subarea AS b ON a.id_subarea = b.id_subarea INNER JOIN departamento AS c ON b.id_dpto = c.id_dpto
INNER JOIN propoe_doc_proj AS d ON a.matricula = d.matricula INNER JOIN projeto AS e ON d.id_projeto = e.id_projeto;

-- Quais os alunos que são bolsistas e respectivos professores orientadores.
-- Esta forma de pesquisa é mais antiga, mas pode ser encontrada em Banco de Dados mais antigos
SELECT a.nome_aluno AS Aluno_bolsista, d.nome_doc AS Professor_orientador 
FROM aluno AS a, projeto AS b, propoe_doc_proj AS c, docente AS d
WHERE a.id_projeto = b.id_projeto AND c.matricula = d.matricula AND c.id_projeto = a.id_projeto;
-- Atualmente as pesquisas são realizadas desta forma, com os JOINs:
SELECT a.nome_aluno AS Aluno_bolsista, d.nome_doc AS Professor_orientador 
from aluno as a inner join projeto as b on a.id_projeto = b.id_projeto 
inner join propoe_doc_proj AS c on c.id_projeto = a.id_projeto 
inner join docente AS d on c.matricula = d.matricula;

-- vamos verificar os dados das principais tabelas que existem no projeto:
SELECT * FROM DOCENTE;
SELECT * FROM DEPARTAMENTO;
select * from curso where nivel_curso = 'MEDIO';
SELECT * FROM CURSO WHERE nivel_curso = 'SUPERIOR';
SELECT * FROM DISCIPLINA;

