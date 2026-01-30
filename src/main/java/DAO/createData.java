package DAO;

import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import Conexao.ConectionFactory;
import Model.Empresa;
import Model.HorarioFuncionamento;
import Model.PasswordUtil;
import Model.Usuario;

public class createData {
    private Connection con;



    public createData(String databaseName) {


        try {
            // Conectar ao MySQL sem especificar um banco de dados para criar o banco
            Connection tempCon = new ConectionFactory().getConnection("");
            if (tempCon == null) {
                System.err.println("Erro: Conexão temporária não foi estabelecida.");
                return;
            }

            // Verifica se o banco de dados já existe e cria se necessário
            createDatabase(tempCon, databaseName);

            // Fechar conexão temporária
            tempCon.close();

            // Conectar ao banco de dados recém-criado
            this.con = new ConectionFactory().getConnection(databaseName);
            if (this.con == null) {
                System.err.println("Erro: Conexão com o novo banco de dados não foi estabelecida.");
                return;
            }

            // Criar tabelas
            createTables();



        } catch (Exception e) {
            System.err.println("Erro ao tentar estabelecer conexão com o banco de dados.");
            e.printStackTrace();
        }
    }

    private void createDatabase(Connection tempCon, String databaseName) throws SQLException {
        Statement statement = tempCon.createStatement();
        try {
            // Verifica se o banco de dados já existe
            String checkDatabaseSQL = "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '" + databaseName + "'";
            ResultSet rs = statement.executeQuery(checkDatabaseSQL);

            if (rs.next()) {
                System.out.println("Banco de dados " + databaseName + " já existe.");
            } else {
                // Criar banco de dados
                String createDatabaseSQL = "CREATE DATABASE " + databaseName;
                statement.executeUpdate(createDatabaseSQL);
                System.out.println("Banco de dados criado com sucesso!");
            }

            rs.close();
        } finally {
            statement.close();
        }
    }

    private void createTables() throws SQLException {
        Statement statement = con.createStatement();
        try {
            // Criação das tabelas
            String createTable_1 = "CREATE TABLE tb_clientes (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "nome varchar(100) DEFAULT NULL," +
                    "rg varchar(30) DEFAULT NULL," +
                    "cpf varchar(20) DEFAULT NULL," +
                    "email varchar(200) DEFAULT NULL," +
                    "telefone varchar(30) DEFAULT NULL," +
                    "celular varchar(30) DEFAULT NULL," +
                    "cep varchar(100) DEFAULT NULL," +
                    "endereco varchar(255) DEFAULT NULL," +
                    "numero int DEFAULT NULL," +
                    "complemento varchar(200) DEFAULT NULL," +
                    "bairro varchar(200) DEFAULT NULL," +
                    "cidade varchar(100) DEFAULT NULL," +
                    "estado varchar(2) DEFAULT NULL," +
                    "PRIMARY KEY (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_1);

            String createTable_2 = "CREATE TABLE tb_fornecedores (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "nome varchar(100) DEFAULT NULL," +
                    "cnpj varchar(100) DEFAULT NULL," +
                    "email varchar(200) DEFAULT NULL," +
                    "telefone varchar(30) DEFAULT NULL," +
                    "celular varchar(30) DEFAULT NULL," +
                    "cep varchar(100) DEFAULT NULL," +
                    "endereco varchar(255) DEFAULT NULL," +
                    "numero int DEFAULT NULL," +
                    "complemento varchar(200) DEFAULT NULL," +
                    "bairro varchar(100) DEFAULT NULL," +
                    "cidade varchar(100) DEFAULT NULL," +
                    "estado varchar(2) DEFAULT NULL," +
                    "PRIMARY KEY (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_2);

            String createTable_3 = "CREATE TABLE tb_funcionarios (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "nome varchar(100) DEFAULT NULL," +
                    "rg varchar(30) DEFAULT NULL," +
                    "cpf varchar(20) DEFAULT NULL," +
                    "email varchar(200) DEFAULT NULL," +
                    "senha varchar(10) DEFAULT NULL," +
                    "cargo varchar(100) DEFAULT NULL," +
                    "nivel_acesso varchar(50) DEFAULT NULL," +
                    "telefone varchar(30) DEFAULT NULL," +
                    "celular varchar(30) DEFAULT NULL," +
                    "cep varchar(100) DEFAULT NULL," +
                    "endereco varchar(255) DEFAULT NULL," +
                    "numero int DEFAULT NULL," +
                    "complemento varchar(200) DEFAULT NULL," +
                    "bairro varchar(100) DEFAULT NULL," +
                    "cidade varchar(100) DEFAULT NULL," +
                    "estado varchar(2) DEFAULT NULL," +
                    "PRIMARY KEY (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_3);

            String createTable_4 = "CREATE TABLE tb_produtos (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "descricao varchar(100) DEFAULT NULL," +
                    "preco_de_compra decimal(10,2) DEFAULT NULL," +
                    "preco_de_venda decimal(10,2) DEFAULT NULL," +
                    "qtd_estoque int DEFAULT NULL," +
                    "for_id int DEFAULT NULL," +
                    "PRIMARY KEY (id)," +
                    "KEY for_id (for_id)," +
                    "imagem LONGBLOB,"+
                    "status varchar (500), " +
                    "CONSTRAINT tb_produtos_ibfk_1 FOREIGN KEY (for_id) REFERENCES tb_fornecedores (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_4);

            String createTable_5 = "CREATE TABLE tb_vendas (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "cliente_id int DEFAULT NULL," +
                    "data_venda datetime DEFAULT NULL," +
                    "total_venda decimal(10,2) DEFAULT NULL," +
                    "observacoes text," +
                    "desconto decimal (10,2)DEFAULT NULL,"+
                    "forma_pagamento varchar(200),"+
                    "idUsuario int DEFAULT NULL,"+
                    "statusVenda varchar(500), " + 
                    "external_reference varchar(500), "+
                    "pgTotalOnline decimal(10,2), "+
                    "PRIMARY KEY (id)," +
                    "KEY cliente_id (cliente_id)," +
                    "CONSTRAINT tb_vendas_ibfk_1 FOREIGN KEY (cliente_id) REFERENCES tb_clientes (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_5);

            String createTable_6 = "CREATE TABLE tb_itensvendas (" +
                    "id int NOT NULL AUTO_INCREMENT," +
                    "venda_id int DEFAULT NULL," +
                    "produto_id int DEFAULT NULL," +
                    "qtd int DEFAULT NULL," +
                    "subtotal decimal(10,2) DEFAULT NULL," +
                    "PRIMARY KEY (id)," +
                    "KEY venda_id (venda_id)," +
                    "KEY produto_id (produto_id)," +
                    "CONSTRAINT tb_itensvendas_ibfk_1 FOREIGN KEY (venda_id) REFERENCES tb_vendas (id)," +
                    "CONSTRAINT tb_itensvendas_ibfk_2 FOREIGN KEY (produto_id) REFERENCES tb_produtos (id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;";
            statement.executeUpdate(createTable_6);



            String createTable_7 = "CREATE TABLE tb_empresa (" +
                    "id INT auto_increment PRIMARY KEY," +
                    "nome VARCHAR(150)," +
                    "cnpj VARCHAR(20)," +
                    "endereco VARCHAR(255)," +
                    "logo LONGBLOB" +
                    ");";
            statement.executeUpdate(createTable_7);

            String createTable_8 = "CREATE TABLE tb_usuario (" +
                    "ID INT auto_increment PRIMARY KEY, " +
                    "NOME VARCHAR(150), " +
                    "TELEFONE VARCHAR(150), " +
                    "EMAIL VARCHAR(150), " +
                    "SENHA VARCHAR(300), " +
                    "empresaID INT DEFAULT NULL, " +
                    "nivel varchar(20), " + 
                    "CONSTRAINT fk_usuario_empresa FOREIGN KEY (empresaID) REFERENCES tb_empresa(id) ON DELETE CASCADE ON UPDATE CASCADE)";

            statement.executeUpdate(createTable_8);
            
            String create_table_9 = "CREATE TABLE `tb_horarios_funcionamento` ( "
            		+ "  `id` int NOT NULL AUTO_INCREMENT, "
            		+ "  `id_empresa` int NOT NULL, "
            		+ "  `dia_semana` int NOT NULL, "
            		+ "  `hora_abertura` time DEFAULT NULL, "
            		+ "  `hora_fechamento` time DEFAULT NULL, "
            		+ "  `aberto` tinyint(1) NOT NULL DEFAULT '1', "
            		+ "  `observacao` varchar(255) DEFAULT NULL, "
            		+ "  PRIMARY KEY (`id`), "
            		+ "  KEY `idx_id_empresa` (`id_empresa`), "
            		+ "  KEY `idx_dia_semana` (`dia_semana`), "
            		+ "  CONSTRAINT `fk_empresa_horario` FOREIGN KEY (`id_empresa`) REFERENCES `tb_empresa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE "
            		+ ")";
            
            
            statement.executeUpdate(create_table_9);
            
            String createTable11 = "CREATE TABLE `tb_cliente_pedido` ( "
            		+ "  `id` int NOT NULL AUTO_INCREMENT, "
            		+ "  `nome` varchar(100) DEFAULT NULL, "
            		+ "  `telefone` varchar(100) DEFAULT NULL, "
            		+ "  `endereco` varchar(100) DEFAULT NULL, "
            		+ "  `numero` varchar(100) DEFAULT NULL, "
            		+ "  `cepPedido` varchar(100)DEFAULT NULL, "
            		+ "  `bairro` varchar(100) DEFAULT NULL, "
            		+ "  `cidade` varchar(100) DEFAULT NULL, "
            		+ "  `estado` varchar(100) DEFAULT NULL, "
            		+ "  `email`  varchar(100) DEFAULT NULL, "
            		+ "  `senha`  varchar(100) DEFAULT NULL, "
            		+ "  PRIMARY KEY (`id`) "
            		+ ")";
            
            statement.executeUpdate(createTable11);
            
            String createtable10 = "CREATE TABLE `pedidos` ( "
            		+ "  `id_pedido` int NOT NULL AUTO_INCREMENT, "
            		+ "  `clientepedido_id` int DEFAULT NULL, "
            		+ "  `data_pedido` timestamp NULL DEFAULT CURRENT_TIMESTAMP, "
            		+ "  `status` varchar(50) DEFAULT NULL, "
            		+ "  `observacoes` text, "
            		+ "  `forma_pagamento` varchar(100) DEFAULT NULL, "
            		+ "  `total_pedido` decimal(10,2) DEFAULT NULL, "
            		+ "  `empresa_id` int DEFAULT NULL,"
            		+ "  `pagamentoPedido` varchar(100), "
            		+ "  `referencialPedido` varchar(100), "
            		+ "  `pgTotalPedidoOnline` decimal(10,2), "
            		+ "  PRIMARY KEY (`id_pedido`), "
            		+ "  KEY `clientepedido_id` (`clientepedido_id`), "
            		+ "  KEY `fk_pedidos_empresa` (`empresa_id`),"
            		+ "  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`clientepedido_id`) REFERENCES `tb_cliente_pedido` (`id`), "
            		+"   CONSTRAINT `fk_pedidos_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `tb_empresa` (`id`)"
            		+ ")";
            statement.executeUpdate(createtable10);

            
            String createTable12 = "CREATE TABLE `itens_pedido` ( "
            		+ "  `id_item` int NOT NULL AUTO_INCREMENT, "
            		+ "  `pedido_id` int DEFAULT NULL, "
            		+ "  `produto_id` int DEFAULT NULL, "
            		+ "  `quantidade` int DEFAULT NULL, "
            		+ "  `preco_unitario` decimal(10,2) DEFAULT NULL, "
            		+ "  PRIMARY KEY (`id_item`), "
            		+ "  KEY `pedido_id` (`pedido_id`), "
            		+ "  KEY `produto_id` (`produto_id`), "
            		+ "  CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id_pedido`), "
            		+ "  CONSTRAINT `itens_pedido_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `tb_produtos` (`id`) "
            		+ ")";
            statement.executeUpdate(createTable12);
            
            String createTable13 = "CREATE TABLE `configuracoes_pagamento` ( "
            		+ "  `id` int NOT NULL AUTO_INCREMENT, "
            		+ "  `empresa_id` int NOT NULL, "
            		+ "  `gateway` varchar(50) NOT NULL, "
            		+ "  `chave_pix` varchar(100) DEFAULT NULL, "
            		+ "  `client_id` varchar(100) DEFAULT NULL, "
            		+ "  `client_secret` varchar(100) DEFAULT NULL, "
            		+ "  `access_token` varchar(255) DEFAULT NULL, "
            		+ "  `publickey` varchar(1000) DEFAULT NULL, "
            		+ "  PRIMARY KEY (`id`), "
            		+ "  KEY `empresa_id` (`empresa_id`), "
            		+ "  CONSTRAINT `configuracoes_pagamento_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `tb_empresa` (`id`) "
            		+ ")";
            statement.executeUpdate(createTable13);
            
            String createTable14 = "CREATE TABLE `funcition_wpp` ("
            		+ "  `id_connection` int NOT NULL AUTO_INCREMENT,"
            		+ "  `id_empresa` int NOT NULL,"
            		+ "  `session_name` varchar(100) DEFAULT NULL,"
            		+ "  `access_token` varchar(200) DEFAULT NULL,"
            		+ "  `session_status` varchar(200) DEFAULT NULL,"
            		+ "  `numero_whatsapp` varchar(100) DEFAULT NULL,"
            		+ "  PRIMARY KEY (`id_connection`),"
            		+ "  KEY `fk_empresa_wpp` (`id_empresa`),"
            		+ "  CONSTRAINT `fk_empresa_wpp` FOREIGN KEY (`id_empresa`) REFERENCES `tb_empresa` (`id`)"
            		+ ")";
            statement.executeUpdate(createTable14);
            
            
            System.out.println("Tabelas criadas com sucesso!");
        } finally {
            statement.close();
        }
    }

    @SuppressWarnings("static-access")
    public int inserirEmpresaUsuario(Empresa emp, Usuario uso, List<HorarioFuncionamento> horarios) throws SQLException {
        
        // Variável para armazenar o ID gerado, declarada fora do try para ser retornada
        int empresaId = 0; 
        
        if (this.con == null) {
            System.err.println("Erro: Conexão com o banco de dados não foi estabelecida.");
            // Retorna 0 (ou lança uma exceção customizada se preferir)
            return 0; 
        }

        // Inicia a transação
        con.setAutoCommit(false);

        String sqlEmpresa = "INSERT INTO tb_empresa (nome, cnpj, endereco, logo) VALUES (?, ?, ?, ?)";
        String sqlUsuario = "INSERT INTO tb_usuario (NOME, TELEFONE, EMAIL, SENHA, empresaID, nivel) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlHorario = "INSERT INTO tb_horarios_funcionamento (id_empresa, dia_semana, hora_abertura, hora_fechamento, aberto, observacao) VALUES (?, ?, ?, ?, ?, ?)";

        try (
            PreparedStatement stmtEmpresa = con.prepareStatement(sqlEmpresa, Statement.RETURN_GENERATED_KEYS);
            PreparedStatement stmtUsuario = con.prepareStatement(sqlUsuario);
            PreparedStatement stmtHorario = con.prepareStatement(sqlHorario)
        ) {
            // Inserindo a empresa
            stmtEmpresa.setString(1, emp.getNome());
            stmtEmpresa.setString(2, emp.getCnpj());
            stmtEmpresa.setString(3, emp.getEndereco());

            if (emp.getLogo() != null) {
                ByteArrayInputStream bais = new ByteArrayInputStream(emp.getLogo());
                stmtEmpresa.setBinaryStream(4, bais, emp.getLogo().length);
            } else {
                stmtEmpresa.setNull(4, Types.BLOB);
            }

            stmtEmpresa.executeUpdate();

            // Obtendo o ID gerado da empresa
            try (ResultSet rs = stmtEmpresa.getGeneratedKeys()) {
                if (rs.next()) {
                    empresaId = rs.getInt(1); // Armazena o ID na variável declarada acima
                }
            }
            
            if (empresaId == 0) {
                 throw new SQLException("Não foi possível obter o ID gerado para a empresa.");
            }

            // Inserindo o usuário associado à empresa
            stmtUsuario.setString(1, uso.getNome());
            stmtUsuario.setString(2, uso.getTelefone());
            stmtUsuario.setString(3, uso.getEmail());
            // Assumindo que PasswordUtil.hashPassword está disponível
            stmtUsuario.setString(4, PasswordUtil.hashPassword(uso.getSenha())); 
            stmtUsuario.setInt(5, empresaId); 
            stmtUsuario.setString(6, "ADM");// Relacionando o usuário à empresa criada

            stmtUsuario.executeUpdate();

            // Inserindo os horários de funcionamento
            if (horarios != null && !horarios.isEmpty()) {
                for (HorarioFuncionamento h : horarios) {
                    stmtHorario.setInt(1, empresaId); // FK da empresa
                    stmtHorario.setInt(2, h.getDiaSemana());
                    
                    // Tratamento para horários nulos se o dia estiver fechado
                    if (h.getHoraAbertura() != null && !h.getHoraAbertura().isEmpty()) {
                        stmtHorario.setString(3, h.getHoraAbertura());
                    } else {
                        stmtHorario.setNull(3, Types.TIME);
                    }

                    if (h.getHoraFechamento() != null && !h.getHoraFechamento().isEmpty()) {
                        stmtHorario.setString(4, h.getHoraFechamento());
                    } else {
                        stmtHorario.setNull(4, Types.TIME);
                    }
                    
                    stmtHorario.setBoolean(5, h.isAberto());
                    
                    if (h.getObservacao() != null && !h.getObservacao().isEmpty()) {
                        stmtHorario.setString(6, h.getObservacao());
                    } else {
                        stmtHorario.setNull(6, Types.VARCHAR);
                    }
                    
                    stmtHorario.addBatch(); // Adiciona ao batch para inserção em massa
                }
                stmtHorario.executeBatch(); // Executa todas as inserções de horário de uma vez
            }


            // Commit da transação
            con.commit();
            System.out.println("Empresa, usuário e horários inseridos com sucesso!");
        } catch (SQLException e) {
            // Rollback em caso de erro
            con.rollback();
            System.err.println("Erro ao inserir empresa, usuário ou horários: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-lança a exceção para que o Servlet possa capturá-la
        } finally {
            // Retorna o auto-commit ao normal
            con.setAutoCommit(true);
        }
        
        // *** SOLUÇÃO DO SEU PROBLEMA: RETORNA O ID AQUI ***
        return empresaId; 
    }
}