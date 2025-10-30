package Controller;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;

import org.json.JSONArray;
import org.json.JSONObject;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.preference.PreferenceBackUrlsRequest;
import com.mercadopago.client.preference.PreferenceClient;
import com.mercadopago.client.preference.PreferenceItemRequest;
import com.mercadopago.client.preference.PreferencePayerRequest;
import com.mercadopago.client.preference.PreferenceRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.resources.preference.Preference;

import Conexao.ConectionFactory;
import DAO.ClientesDAO;
import DAO.ConfigPagamentoDAO;
import DAO.EmpresaDAO;
import DAO.itensVendaDAO; // 💡 Corrigido para ItensVendaDAO
import DAO.ProdutosDAO;
import DAO.UsuarioDAO;
import DAO.VendasDAO;
import Model.Clientes;
import Model.ConfigPagamento;
import Model.Empresa;
import Model.ItensVenda;
import Model.Produtos;
import Model.Usuario;
import Model.Vendas;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;


/**
 * Servlet implementation class VendasServlet
 */
// 💡 Nome do servlet ajustado para VendasServlet
@WebServlet(urlPatterns = { "/selecionarClienteProdutos", "/inserirItens", "/InseirVendaEintens", "/PeriodoVenda",
		"/dia", "/maisVendidos","/exibirRelatorio","/lucroVenda" ,"/lucroPeriodo","/desconto","/relVenda","/exibirRelatorio2"})
@MultipartConfig
public class VendasServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	 private static final Logger LOGGER = Logger.getLogger(VendasServlet.class.getName());

	double total, subtotal, preco, meuPreco;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public VendasServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 * response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Obtendo a sessão
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		if (empresa != null) {
			System.out.println("Empresa selecionada: " + empresa);
		} else {
			System.out.println("Nenhuma empresa selecionada.");
		}

		String action = request.getServletPath();
		switch (action) {
		case "/exibirRelatorio2":
			try {
				// 💡 Ação original para a última venda (reutilizando a lógica)
				VendasDAO vendasDAO = new VendasDAO(empresa);
				int cdVenda = vendasDAO.retornaUltimaVenda();
				executarGeracaoRelatorio(request, response, cdVenda);
			} catch (Exception e) { // Captura todas as exceptions que o novo método pode lançar
				e.printStackTrace();
			}
			break;
		case "/selecionarClienteProdutos":
			try {
				selecionarClienteProd(request, response);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			break;
		case "/inserirItens":
			inserirItens(request, response);
			break;
		case "/InseirVendaEintens":
			inserirVendas(request, response);
			break;
		case "/PeriodoVenda":
			vendaPorPeriodo(request, response);
			break;
		case "/dia":
			vendaPorDia(request, response);
			break;
		case "/maisVendidos":
			maisVendidos(request, response);
			break;
		case "/exibirRelatorio":
			try {
				gerarRelatorio(request, response);
			} catch (ClassNotFoundException | ServletException | IOException | NamingException e) {
				e.printStackTrace();
			}
			break;
		case "/relVenda":
			try {
				relVenda(request, response);
			} catch (ClassNotFoundException | ServletException | IOException | NamingException e) {
				e.printStackTrace();
			}
			break;
		case "/lucroVenda":
			lucroVenda(request, response);
			break;
		case "/lucroPeriodo":
			lucroPeriodo(request, response);
			break;
		case "/desconto":
			descontoVenda(request, response);
			break;
		default:
			response.getWriter().append("Ação não reconhecida.");
			break;
		}
	}
	protected void descontoVenda(HttpServletRequest request, HttpServletResponse response) {
	    try {
	        String descontotela = request.getParameter("desconto");
	        String totalVenda = request.getParameter("totalVendaAtualizado");

	        if (descontotela != null && totalVenda != null) {
	            try {
	                double descontoValor = Double.parseDouble(descontotela);
	                double vendaTela = Double.parseDouble(totalVenda);
	                double descontoFinal = vendaTela - descontoValor;
	                HttpSession session = request.getSession();
	                session.setAttribute("totalVendaAtualizado", descontoFinal);
	                RequestDispatcher dispatcher = request.getRequestDispatcher("realizarVendas.jsp");
	                dispatcher.forward(request, response);
	            } catch (NumberFormatException e) {
	                e.printStackTrace();
	                response.getWriter().println("Erro: valores inválidos para cálculo.") ;
	            }
	        } else {
	            response.getWriter().println("Erro: parâmetros 'desconto' e 'totalVenda' não enviados.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        try {
				response.getWriter().println("Erro interno no servidor: " + e.getMessage());
			} catch (IOException e1) {
				e1.printStackTrace();
			}
	    }
	}

	private void lucroPeriodo(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String datalucroinicio = request.getParameter("dataIniciallucro");
		String datalucrofim = request.getParameter("dataFinallucro");
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		if (datalucroinicio != null && datalucrofim != null) {
			String fomatoData = "dd/MM/yyyy";
			SimpleDateFormat sdf = new SimpleDateFormat(fomatoData);

			try {
				Date datainicalFormata = sdf.parse(datalucroinicio);
				Date datafinalFormata = sdf.parse(datalucrofim);
				VendasDAO dao = new VendasDAO(empresa);
				double lucroPeriodo = dao.lucroPorPeriod(datainicalFormata, datafinalFormata);
				request.setAttribute("totalLucro", lucroPeriodo);
				RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
				dispatcher.forward(request, response);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
	}
	protected void lucroVenda(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String codigoVenda = request.getParameter("CodigoVenda");
		int idVenda = Integer.parseInt(codigoVenda);
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		try {
			VendasDAO dao = new VendasDAO(empresa);
			double lucroVenda = dao.lucroVenda(idVenda);
			request.setAttribute("lucro", lucroVenda);
			request.setAttribute("vendaCodigo", idVenda);
			RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
			dispatcher.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			// Handle exception appropriately
		}
	}
	// 💡 Novo método auxiliar para gerar o relatório com base no ID da venda.
		private void executarGeracaoRelatorio(HttpServletRequest request, HttpServletResponse response, int cdVenda)
				throws ServletException, IOException, NamingException, ClassNotFoundException {

			HttpSession session = request.getSession();
			String empresa = (String) session.getAttribute("empresa");

			if (empresa == null) {
				response.getWriter().write("Empresa não fornecida.");
				LOGGER.log(Level.WARNING, "Empresa não fornecida.");
				return;
			}

			// A conexão será automaticamente fechada (AutoCloseable)
			try (Connection connection = new ConectionFactory().getConnection(empresa)) {

				String jasperPath = "RelatorioJasper/novoComprovante.jasper";
				// Usamos o getResourceAsStream para garantir que funcione em diferentes ambientes
				InputStream jasperStream = getClass().getClassLoader().getResourceAsStream(jasperPath);

				if (jasperStream == null) {
					response.getWriter()
							.write("Arquivo JASPER não encontrado: " + jasperPath + ". Verifique se está em src/main/resources/");
					LOGGER.log(Level.SEVERE, "Arquivo JASPER não encontrado: {0}", jasperPath);
					return;
				}

				// Carregando o relatório
				JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);

				Map<String, Object> parametros = new HashMap<>();
				UsuarioDAO usuarioDAO = new UsuarioDAO(empresa);

				// Aqui é importante garantir que o ID da empresa seja recuperado corretamente
				Empresa empresaObj = usuarioDAO.retornCompany(new Empresa(), empresa, 0);
				// Usando o valor fixo '1' como fallback, conforme seu requisito (mas idealmente
				// deve ser dinâmico)
				int cdEmpresa = 1; // (empresaObj != null) ? empresaObj.getId() : 1; 

				parametros.put("cdEmpresa", cdEmpresa);
				parametros.put("cdVenda", cdVenda); // Usando o ID da venda recém-criada

				JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parametros, connection);
				ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();
				JasperExportManager.exportReportToPdfStream(jasperPrint, pdfOutputStream);
				byte[] pdfBytes = pdfOutputStream.toByteArray();

				response.setContentType("application/pdf");
				// 💡 Usando 'attachment' para que o navegador baixe ou abra em uma nova aba,
				// mas 'inline' abre na mesma. Mantendo 'inline' para abrir na tela.
				response.setHeader("Content-Disposition", "inline; filename=relatorio_venda_" + cdVenda + ".pdf");
				response.setContentLength(pdfBytes.length);

				try (OutputStream outStream = response.getOutputStream()) {
					outStream.write(pdfBytes);
					outStream.flush();
				}
			} catch (SQLException | JRException e) {
				LOGGER.log(Level.SEVERE, "Erro ao gerar relatório para a empresa: " + empresa, e);
				response.getWriter().write("Erro ao gerar relatório: " + e.getMessage());
			}
		}

	@SuppressWarnings({ "unused"})
	protected void gerarRelatorio(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException, ClassNotFoundException, NamingException {

	    HttpSession session = request.getSession();
	    String empresa = (String) session.getAttribute("empresa");

	    if (empresa == null) {
	        response.getWriter().write("Empresa não fornecida.");
	        // LOGGER.log(Level.WARNING, "Empresa não fornecida."); // Mantenha seu log aqui
	        return;
	    }

	    // A conexão será automaticamente fechada (AutoCloseable)
	    try (Connection connection = new ConectionFactory().getConnection(empresa)) {
	        
	        // Removido: Thread.sleep(1000); - O Jasper não requer delay.
	        
	        String jasperPath = "RelatorioJasper/novoComprovante.jasper";
	        // Caminho de carregamento é PERFEITO para ambiente Maven
	        InputStream jasperStream = getClass().getClassLoader().getResourceAsStream(jasperPath);
	        
	        if (jasperStream == null) {
	            response.getWriter().write("Arquivo JASPER não encontrado: " + jasperPath + ". Verifique se está em src/main/resources/");
	            // LOGGER.log(Level.SEVERE, "Arquivo JASPER não encontrado: {0}", jasperPath); // Mantenha seu log aqui
	            return;
	        }

	        // --- Ponto Crítico de Incompatibilidade ---
	        // A falha ocorre ao carregar este objeto, devido à versão.
	        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);
	        
	        // O restante do código está ótimo e funcional
	        Map<String, Object> parametros = new HashMap<>();
	        UsuarioDAO usuarioDAO = new UsuarioDAO(empresa);
	        VendasDAO vendasDAO = new VendasDAO(empresa);
	        
	        Empresa empresaObj = usuarioDAO.retornCompany(new Empresa(), empresa, 0);
	        int cdVenda = vendasDAO.retornaUltimaVenda();
	        int cdEmpresa = (empresaObj != null) ? empresaObj.getId() : 0;
	        
	        parametros.put("cdEmpresa", cdEmpresa);
	        parametros.put("cdVenda", cdVenda);
	        
	        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parametros, connection);
	        ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();
	        JasperExportManager.exportReportToPdfStream(jasperPrint, pdfOutputStream);
	        byte[] pdfBytes = pdfOutputStream.toByteArray();
	        
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "inline; filename=relatorio_venda.pdf");
	        response.setContentLength(pdfBytes.length);

	        try (OutputStream outStream = response.getOutputStream()) {
	            outStream.write(pdfBytes);
	            outStream.flush();
	        }
	    } catch (SQLException | JRException | NamingException e) {
	        // LOGGER.log(Level.SEVERE, "Erro ao gerar relatório para a empresa: " + empresa, e); // Mantenha seu log aqui
	        response.getWriter().write("Erro ao gerar relatório: " + e.getMessage());
	    }
	}
	protected void relVenda(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException, ClassNotFoundException, NamingException {

	    HttpSession session = request.getSession();
	    String empresa = (String) session.getAttribute("empresa");

	    if (empresa == null) {
	        response.getWriter().write("Empresa não fornecida.");
	        LOGGER.log(Level.WARNING, "Empresa não fornecida.");
	        return;
	    }

	    String vendaIDParam = request.getParameter("vendaID");
	    int cdVenda = 0;

	    if (vendaIDParam != null && !vendaIDParam.isEmpty()) {
	        try {
	            cdVenda = Integer.parseInt(vendaIDParam);
	        } catch (NumberFormatException e) {
	            LOGGER.log(Level.WARNING, "ID da venda inválido: " + vendaIDParam, e);
	            response.getWriter().write("ID da venda inválido.");
	            return;
	        }
	    }

	    if (cdVenda == 0) {
	        response.getWriter().write("ID da venda não foi fornecido corretamente.");
	        LOGGER.log(Level.WARNING, "ID da venda não foi fornecido corretamente.");
	        return;
	    }

	    try (Connection connection = new ConectionFactory().getConnection(empresa)) {
	        String jasperPath = "RelatorioJasper/vendaSelecionada.jasper";
	        InputStream jasperStream = getClass().getClassLoader().getResourceAsStream(jasperPath);

	        if (jasperStream == null) {
	            response.getWriter().write("Arquivo JASPER não encontrado: " + jasperPath);
	            LOGGER.log(Level.SEVERE, "Arquivo JASPER não encontrado: {0}", jasperPath);
	            return;
	        }

	        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);
	        Map<String, Object> parametros = new HashMap<>();
	        UsuarioDAO usuarioDAO = new UsuarioDAO(empresa);

	        Empresa empresaObj = usuarioDAO.retornCompany(new Empresa(), empresa, 0);
	        int cdEmpresa = (empresaObj != null) ? empresaObj.getId() : 0;
	        parametros.put("cdEmpresa", cdEmpresa);
	        parametros.put("cdVenda", cdVenda);
	        System.out.println("Empresa selecionada: " + empresa);
	        System.out.println("Código da venda: " + cdVenda);
	        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parametros, connection);
	        ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();
	        JasperExportManager.exportReportToPdfStream(jasperPrint, pdfOutputStream);
	        byte[] pdfBytes = pdfOutputStream.toByteArray();
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "inline; filename=relatorio_venda.pdf");
	        response.setContentLength(pdfBytes.length);

	        try (OutputStream outStream = response.getOutputStream()) {
	            outStream.write(pdfBytes);
	            outStream.flush();
	        }
	    } catch (SQLException | JRException e) {
	        LOGGER.log(Level.SEVERE, "Erro ao gerar relatório para a empresa: " + empresa, e);
	        response.getWriter().write("Erro ao gerar relatório: " + e.getMessage());
	    }
	}

	private void maisVendidos(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String dataVendainicio = request.getParameter("dataVendainicio");
		String dataVendafim = request.getParameter("dataVendafim");
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		if (dataVendainicio != null && dataVendafim != null) {
			String fomatoData = "dd/MM/yyyy";
			SimpleDateFormat sdf = new SimpleDateFormat(fomatoData);
			try {
				Date datainicalFormata = sdf.parse(dataVendainicio);
				Date datafinalFormata = sdf.parse(dataVendafim);
				VendasDAO dao = new VendasDAO(empresa);
				ArrayList<ItensVenda> lista_2 = (ArrayList<ItensVenda>) dao.maisVendidos(datainicalFormata,
						datafinalFormata);
				request.setAttribute("maisVendidos", lista_2);
				RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
				dispatcher.forward(request, response);
			} catch (Exception e) {
			}
		}
	}

	private void vendaPorDia(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String data = request.getParameter("data");
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		try {
			SimpleDateFormat dataVenda = new SimpleDateFormat("dd/MM/yyyy");
			Date dataVendaInf = dataVenda.parse(data);
			VendasDAO dao = new VendasDAO(empresa);
			double totalVenda = dao.retornaTotalVendaPorData(dataVendaInf);
			request.setAttribute("totalVenda2", totalVenda);
			request.setAttribute("data", data);
			RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
			dispatcher.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void vendaPorPeriodo(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String dataInicial = request.getParameter("dataInicial");
		String dataFinal = request.getParameter("dataFinal");
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		if (dataInicial != null && dataFinal != null) {
			String fomatoData = "dd/MM/yyyy";
			SimpleDateFormat sdf = new SimpleDateFormat(fomatoData);

			try {
				Date datainicalFormata = sdf.parse(dataInicial);
				Date datafinalFormata = sdf.parse(dataFinal);
				VendasDAO dao = new VendasDAO(empresa);
				ArrayList<Vendas> lista_2 = (ArrayList<Vendas>) dao.totalPorPeriodo(datainicalFormata,
						datafinalFormata);
				request.setAttribute("periodo", lista_2);
				RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
				dispatcher.forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void inserirVendas(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		try {
			String empresaBase = (String) session.getAttribute("empresa");
			if (empresaBase == null || empresaBase.isEmpty()) {
				System.err.println("Erro: Nome da base da empresa não definido na sessão.");
				response.sendRedirect("erroPagamento.jsp?msg=empresa-base-nao-definida");
				return;
			}

			String empresaNome = request.getParameter("empresaNome");
			if (empresaNome == null || empresaNome.isEmpty()) {
				empresaNome = empresaBase;
			}

			// 💡 Simplificando: Assumindo ID fixo 1 conforme seu requisito
			Integer empresaId = 1;
			session.setAttribute("empresaId", empresaId);

			Integer usuarioID = (Integer) session.getAttribute("usuarioID");

			String idCliStr = request.getParameter("cliId");
			String totalVendaStr = request.getParameter("iserirtotal");
			String descontoStr = request.getParameter("desconto");
			String formaPagamento = request.getParameter("formaPagamento");

			int idCli = (idCliStr != null && !idCliStr.isEmpty()) ? Integer.parseInt(idCliStr) : 0;
			double totalVenda = (totalVendaStr != null && !totalVendaStr.isEmpty()) ? Double.parseDouble(totalVendaStr)
					: 0.0;
			double desconto = (descontoStr != null && !descontoStr.isEmpty()) ? Double.parseDouble(descontoStr) : 0.0;

			Vendas obj = new Vendas();
			if (idCli > 0) {
				Clientes objCli = new Clientes();
				objCli.setId(idCli);
				obj.setCliente(objCli);
			}
			obj.setData_venda(request.getParameter("data"));
			obj.setTotal_venda(totalVenda);
			obj.setObs(request.getParameter("observacao"));
			obj.setDesconto(desconto);
			obj.setFormaPagamento(formaPagamento);

			if (usuarioID != null && usuarioID > 0) {
				Usuario objUser = new Usuario();
				objUser.setId(usuarioID);
				obj.setUsuario(objUser);
			}

			VendasDAO dao = new VendasDAO(empresaBase);
			// 1. Cadastra a Venda
			dao.cadastrarVenda(obj);
			obj.setId(dao.retornaUltimaVenda()); // Obtém o ID da venda recém-criada

			// 2. Insere os Itens da Venda e Baixa o Estoque
			JSONArray itensArray = (JSONArray) session.getAttribute("itens");
			if (itensArray != null && itensArray.length() > 0) {
				for (int i = 0; i < itensArray.length(); i++) {
					JSONObject linha = itensArray.getJSONObject(i);

					int idProdVenda = Integer.parseInt(linha.getString("idProd"));
					int qtdProd = Integer.parseInt(linha.getString("qtdProd"));
					double subItens = Double.parseDouble(linha.getString("subtotal"));

					ProdutosDAO dao_produto = new ProdutosDAO(empresaBase);
					itensVendaDAO daoitem = new itensVendaDAO(empresaBase);

					Produtos objp = new Produtos();
					ItensVenda itens = new ItensVenda();

					itens.setVenda(obj);
					objp.setId(idProdVenda);
					itens.setProduto(objp);
					itens.setQtd(qtdProd);
					itens.setSubtotal(subItens);

					int qtd_estoque = dao_produto.retornaEstoqueAtual(objp.getId());
					dao_produto.baixarEstoque(objp.getId(), qtd_estoque - qtdProd);

					daoitem.cadastraItem(itens);
				}
				session.removeAttribute("itens");
				session.removeAttribute("desconto");
				session.removeAttribute("totalVenda");
				session.removeAttribute("totalVendaAtualizado");
			}

			// 3. 🚦 Lógica de Pagamento / Relatório
			if ("MERCADOPAGO".equalsIgnoreCase(formaPagamento)) {
				// 🔹 INTEGRAÇÃO MERCADO PAGO - O fluxo segue para o checkout
				ConfigPagamentoDAO cfgDao = new ConfigPagamentoDAO(empresaBase);
				ConfigPagamento cfg = cfgDao.buscarPorEmpresa(empresaId);

				if (cfg == null || cfg.getAccessToken() == null || cfg.getAccessToken().isEmpty()) {
					System.err.println("Erro: Configuração de pagamento inválida para empresaId " + empresaId);
					response.sendRedirect("erroPagamento.jsp?msg=access-token-invalido");
					return;
				}

				try {
					MercadoPagoConfig.setAccessToken(cfg.getAccessToken());
					PreferenceClient client = new PreferenceClient();

					String externalReference = empresaBase + "_" + obj.getId();

					PreferenceItemRequest itemRequest = PreferenceItemRequest.builder()
							.title("Venda #" + obj.getId())
							.quantity(1)
							.unitPrice(new BigDecimal(obj.getTotal_venda()))
							.currencyId("BRL")
							.build();

					// Obtém URL do Ngrok (necessário para BackUrls e NotificationUrl)
					String ngrokBaseUrl = getNgrokTunnelUrl();
					if (ngrokBaseUrl == null) {
						System.err.println("Erro: Não foi possível obter a URL do Ngrok. Verifique se o Ngrok está rodando.");
						response.sendRedirect("erroPagamento.jsp?msg=ngrok-nao-online");
						return;
					}

					System.out.println("URL de notificação a ser enviada para o Mercado Pago: " + ngrokBaseUrl + "/PDVVenda/mercadopago-webhook");

					PreferenceBackUrlsRequest backUrls = PreferenceBackUrlsRequest.builder()
							.success(ngrokBaseUrl + "/PDVVenda/pagamento-sucesso")
							.failure(ngrokBaseUrl + "/PDVVenda/pagamento-falhou")
							.pending(ngrokBaseUrl + "/PDVVenda/pagamento-pendente")
							.build();

					PreferencePayerRequest payer = PreferencePayerRequest.builder()
							.name(request.getParameter("nomeCliente"))
							.email(request.getParameter("emailCliente"))
							.build();

					PreferenceRequest prefRequest = PreferenceRequest.builder()
							.items(Collections.singletonList(itemRequest))
							.externalReference(externalReference)
							.backUrls(backUrls)
							.payer(payer)
							.autoReturn("approved")
							.notificationUrl(ngrokBaseUrl + "/PDVVenda/mercadopago-webhook")
							.build();

					Preference pref = client.create(prefRequest);

					request.setAttribute("preferenceId", pref.getId());
					request.setAttribute("publicKey", cfg.getPublicKey());
					request.setAttribute("initPoint", pref.getInitPoint());
					request.setAttribute("totalVenda", obj.getTotal_venda());
					request.setAttribute("nomeCliente", request.getParameter("nomeCliente"));
					request.setAttribute("emailCliente", request.getParameter("emailCliente"));

					// Redireciona para o checkout do MP. O relatório NÃO é gerado agora.
					request.getRequestDispatcher("checkout.jsp").forward(request, response);

					return;

				} catch (MPApiException e) {
					System.err.println("Erro na API do Mercado Pago: " + e.getApiResponse().getContent());
					response.sendRedirect("erroPagamento.jsp?msg=erro-api-mp");
					return;
				} catch (Exception e) {
					System.err.println("Erro na integração com Mercado Pago:");
					e.printStackTrace();
					response.sendRedirect("erroPagamento.jsp?msg=erro-geral-mp");
					return;
				}
			} else {
				// 🔹 OUTRAS FORMAS DE PAGAMENTO - Gera o relatório e exibe imediatamente
				try {
					// 💡 CHAMA O NOVO MÉTODO
					executarGeracaoRelatorio(request, response, obj.getId());
					// Não precisa de forward/redirect, pois a resposta é o PDF
					return;
				} catch (NamingException e) {
					System.err.println("Erro de Naming ao gerar relatório:");
					e.printStackTrace();
					response.getWriter().write("Erro ao gerar relatório (Naming): " + e.getMessage());
					return;
				}
			}

			// Se houver algum erro ou se o fluxo cair aqui sem gerar o PDF (o que não
			// deveria acontecer no ELSE), redireciona.
			// response.sendRedirect("realizarVendas.jsp"); // Comentei para evitar que a
			// resposta seja duplicada após a geração do PDF.

		} catch (NumberFormatException e) {
			System.err.println("Erro de conversão de número. Verifique os parâmetros.");
			e.printStackTrace();
			response.sendRedirect("erroPagamento.jsp?msg=formato-numero-invalido");
		} catch (Exception e) {
			System.err.println("Erro geral no processo de vendas.");
			e.printStackTrace();
			response.sendRedirect("erroPagamento.jsp?msg=erro-geral");
		}
	}

    private String getNgrokTunnelUrl() {
        try {
            URL url = new URL("http://127.0.0.1:4040/api/tunnels");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000); 
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                System.err.println("Erro ao conectar na API do Ngrok: " + conn.getResponseCode());
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) {
                response.append(output);
            }
            conn.disconnect();

            JSONObject json = new JSONObject(response.toString());
            JSONArray tunnels = json.getJSONArray("tunnels");

            for (int i = 0; i < tunnels.length(); i++) {
                JSONObject tunnel = tunnels.getJSONObject(i);
                if (tunnel.getString("proto").equals("https")) {
                    return tunnel.getString("public_url");
                }
            }

        } catch (IOException e) {
            System.err.println("Erro de I/O ao tentar conectar na API do Ngrok: " + e.getMessage());
        }
        return null;
    }

	
	private void inserirItens(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    HttpSession session = request.getSession();

	    try {
	        BufferedReader reader = request.getReader();
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = reader.readLine()) != null) {
	            sb.append(line);
	        }
	        JSONObject itemJson = new JSONObject(sb.toString());

	        String idProd = itemJson.getString("idProd");
	        String desProd = itemJson.getString("desProd");
	        String qtdProd = itemJson.getString("qtdProd");
	        String precoProd = itemJson.getString("precoProd");
	        String precoMeu = itemJson.getString("compraProd");

	        if (qtdProd != null) {
	            int qtdPrdo = Integer.parseInt(qtdProd);
	            double preco = Double.parseDouble(precoProd);
	            double meuPreco = Double.parseDouble(precoMeu);

	            double subtotal = qtdPrdo * preco;
	            double total = 0.0;

	            if (session.getAttribute("totalVendaAtualizado") != null) {
	                total = (double) session.getAttribute("totalVendaAtualizado");
	            }

	            total += subtotal;

	            String newRow = "<tr>" + "<td>" + idProd + "</td>" + "<td>" + desProd + "</td>" + "<td>" + qtdProd
	                    + "</td>" + "<td>" + precoProd + "</td>" + "<td>" + subtotal + "</td>" + "</tr>";

	            JSONObject newItem = new JSONObject();

	            newItem.put("idProd", idProd);
	            newItem.put("desProd", desProd);
	            newItem.put("qtdProd", qtdProd);
	            newItem.put("precoProd", precoProd);
	            newItem.put("subtotal", String.valueOf(subtotal));
	            newItem.put("totalVendaAtualizado", String.valueOf(total));

	            JSONArray itens = (JSONArray) session.getAttribute("itens");

	            if (itens == null) {
	                itens = new JSONArray();
	            }

	            itens.put(newItem);

	            session.setAttribute("itens", itens);
	            session.setAttribute("totalVendaAtualizado", total);

	            PrintWriter out = response.getWriter();
	            out.println(newRow);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	private void selecionarClienteProd(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, ClassNotFoundException {
		String cpfCli = request.getParameter("cliCpf");
		String idProdStr = request.getParameter("idProd");
		int idProd = Integer.parseInt(idProdStr);
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		try {
			Produtos prod = new Produtos();
			ProdutosDAO prodDAO = new ProdutosDAO(empresa);
			Clientes cli = new Clientes();
			ClientesDAO cliDAO = new ClientesDAO(empresa);

			cli = cliDAO.consultarClientesPorcpf(cpfCli);
			request.setAttribute("cliId", cli.getId());
			request.setAttribute("cliNome", cli.getNome());
			request.setAttribute("cliCpf", cli.getCpf());
			request.setAttribute("cliEndereco", cli.getEndereco());
			request.setAttribute("cliNumero", cli.getNumero());
			prod = prodDAO.consultarPorCodigo(idProd);
			request.setAttribute("idProd", prod.getId());
			request.setAttribute("desProd", prod.getDescricao());
			request.setAttribute("compraProd", prod.getPreco_de_compra());
			request.setAttribute("precoProd", prod.getPreco_de_venda());
			RequestDispatcher rd = request.getRequestDispatcher("realizarVendas.jsp");
			rd.forward(request, response);
		} catch (Exception e) {
		}
		session.isNew();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
