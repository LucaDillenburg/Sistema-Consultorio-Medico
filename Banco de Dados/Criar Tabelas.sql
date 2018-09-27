create table medico(
email varchar(50) primary key,
nomeCompleto varchar(50) not null,
crm varchar(13) not null, -- CRM é formado somente por números seguido da Sigla do Estado ex: 0000/SP minímo 4 dígitos ou 0000000000/SP máximo 10 dígitos
celular varchar(14) not null,
telefoneResidencial varchar(13) not null,
endereco varchar(100) not null,
dataDeNascimento datetime not null,
foto image null,
senha varchar(256) not null
)

create table paciente(
email varchar(50) primary key,
nomeCompleto varchar(50) not null,
celular varchar(14) not null,
telefoneResidencial varchar(13) not null,
endereco varchar(100) not null,
dataDeNascimento datetime not null,
foto image null,
senha varchar(256) not null
)

create table secretaria(
email varchar(50) primary key,
nomeCompleto varchar(50) not null,
endereco varchar(100) not null,
senha varchar(256) not null
)

create table consulta(
codConsulta int identity(1,1) primary key,
proposito varchar(50) not null,
horario datetime not null,
umaHora bit not null, --0: meia hora, 1: uma hora
observacoes ntext null,
status char(1) not null, --n: ainda nao ocorrido, s: ocorrido, c: cancelado
emailMedico varchar(50) not null,
emailPac varchar(50) not null,
satisfacao int null,
comentario ntext null,
horarioSatisfacao datetime null,
medicoJahViuSatisfacao bit null,

constraint fkMedicoConsulta foreign key (emailMedico)
references medico(email),
constraint fkPacConsulta foreign key (emailPac)
references paciente(email)
)

create table especialidade(
codEspecialidade int primary key,
nomeEspecialidade varchar(30) not null
)

create table especialidadeMedico(
codEspMedico int identity(1,1) primary key,
emailMedico varchar(50) not null,
codEspecialidade int not null,

constraint fkMedicoEspMed foreign key (emailMedico)
references medico(email),
constraint fkEspecialidadeEspMed foreign key (codEspecialidade)
references especialidade(codEspecialidade)
)

create table acesso(
codAcesso int identity(1,1) primary key,
data datetime not null,
email varchar(50) not null,
tipo char(1) not null, --'p': paciente, 'm':medico, 's':secretaria 
)