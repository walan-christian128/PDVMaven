package Controller;

import java.awt.Image;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;
import javax.naming.NamingException;

import DAO.ProdutosDAO;
import Model.Fornecedores;
import Model.Produtos;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class produtosServer
 */
@MultipartConfig
@WebServlet(urlPatterns = { "/main", "/insert", "/select", "/updateProduto", "/delete" })
public class produtosServer extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public produtosServer() {
		super();

		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		String action = request.getServletPath();
		System.out.println(action);
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");


		if (action.equals("/insert")) {
			CadastrandoProdutos(request, response);
		} else if (action.equals("/select")) {
			try {
				listandoProduto(request, response);
			} catch (ClassNotFoundException | ServletException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NamingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		else if (action.equals("/updateProduto")) {
			try {
				atualizarProduto(request, response);
			} catch (ServletException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if (action.equals("/delete")) {
			ApagarProdutos(request, response);
		} else {
			response.sendRedirect("Produtos.jsp");

		}
	}

	private void listandoProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, ClassNotFoundException, NamingException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		Produtos prod = new Produtos();
		ProdutosDAO dao = new ProdutosDAO(empresa);
		String idProduto = request.getParameter("id");
		try {
			prod.setId(Integer.parseInt(idProduto));

			dao.consultarProduto(prod);
			request.setAttribute("id", prod.getId());
			request.setAttribute("descricao", prod.getDescricao());
			request.setAttribute("qtd_estoque", prod.getQtd_estoque());
			request.setAttribute("preco_de_compra", prod.getPreco_de_compra());
			request.setAttribute("preco_de_venda", prod.getPreco_de_venda());
			request.setAttribute("status", prod.getStatus());
			request.setAttribute("logo", prod.getImagem());
			
			request.setAttribute("for_id", prod.getFornecedor().getNome());
		} catch (Exception e) {
			// TODO: handle exception
		}

		RequestDispatcher rd = request.getRequestDispatcher("EditarProduto.jsp");
		rd.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		doGet(request, response);
			}
	
	  private Image converterImagem(byte[] imagemBytes) {
	        try {
	            ByteArrayInputStream is = new ByteArrayInputStream(imagemBytes);
	            return ImageIO.read(is);
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        }
	    }

	  protected void CadastrandoProdutos(HttpServletRequest request, HttpServletResponse response)
		        throws ServletException, IOException {
		    
		    // Configura a codificação de caracteres para evitar problemas com acentos.
		    request.setCharacterEncoding("UTF-8");

		    HttpSession session = request.getSession();
		    String empresa = (String) session.getAttribute("empresa");

		    // Verifica se a sessão da empresa está ativa.
		    if (empresa == null || empresa.isEmpty()) {
		        response.sendRedirect("LoginExpirado.jsp");
		        return;
		    }

		    Produtos prod = new Produtos();
		    
		    // Variável para armazenar o ID do fornecedor como string, para ser processado depois.
		    String fornecedorIdString = null;

		    try {
		        // Itera sobre TODAS as partes da requisição, tanto campos de texto quanto arquivos.
		        for (Part part : request.getParts()) {
		            String fieldName = part.getName();
		            
		            // Verifica se a parte é um campo de texto, não um arquivo.
		            if (part.getSubmittedFileName() == null) {
		                // Lê o valor do campo de texto do InputStream.
		                String fieldValue = new String(part.getInputStream().readAllBytes(), "UTF-8");

		                // Atribui o valor ao atributo correspondente do objeto Produtos.
		                switch (fieldName) {
		                    case "descricao":
		                        prod.setDescricao(fieldValue);
		                        break;
		                    case "qtd_estoque":
		                        // Verifica se o valor não está vazio antes de converter para Integer.
		                        if (fieldValue != null && !fieldValue.isEmpty()) {
		                            prod.setQtd_estoque(Integer.parseInt(fieldValue));
		                        }
		                        break;
		                    case "preco_de_compra":
		                        // Verifica se o valor não está vazio e substitui a vírgula por ponto.
		                        if (fieldValue != null && !fieldValue.isEmpty()) {
		                            prod.setPreco_de_compra(Double.parseDouble(fieldValue.replace(",", ".")));
		                        }
		                        break;
		                    case "preco_de_venda":
		                        // Verifica se o valor não está vazio e substitui a vírgula por ponto.
		                        if (fieldValue != null && !fieldValue.isEmpty()) {
		                            prod.setPreco_de_venda(Double.parseDouble(fieldValue.replace(",", ".")));
		                        }
		                        // Adicione o 'break;' aqui para evitar que o próximo 'case' seja executado.
		                        break; 
		                    case "status":
		                        prod.setStatus(fieldValue);
		                        break;
		                    case "for_id":
		                        // Armazena o ID do fornecedor para ser processado após a iteração.
		                        fornecedorIdString = fieldValue; 
		                        break;
		                }
		            } else { // Se a parte for um arquivo (a imagem).
		                if ("logo".equals(fieldName) && part.getSize() > 0) {
		                    try (InputStream inputStream = part.getInputStream()) {
		                        byte[] logoBytes = inputStream.readAllBytes();
		                        prod.setImagem(logoBytes);
		                    }
		                }
		            }
		        }

		        // Processa o ID do fornecedor após a iteração, garantindo que o valor foi capturado.
		        if (fornecedorIdString != null && !fornecedorIdString.isEmpty()) {
		            Fornecedores fornecedores = new Fornecedores();
		            fornecedores.setId(Integer.parseInt(fornecedorIdString));
		            prod.setFornecedor(fornecedores);
		        }

		        // Realiza o cadastro no banco de dados se a descrição foi preenchida.
		        if (prod.getDescricao() != null && !prod.getDescricao().trim().isEmpty()) {
		            ProdutosDAO dao = new ProdutosDAO(empresa);
		            dao.cadastrar(prod);
		            response.sendRedirect("Produtos.jsp");
		        } else {
		            // Se a descrição estiver vazia, redireciona para uma página de erro.
		            request.setAttribute("erro", "A descrição do produto não pode ser vazia.");
		            request.getRequestDispatcher("erro.jsp").forward(request, response);
		        }

		    } catch (Exception e) {
		        // Captura e trata qualquer exceção que possa ocorrer durante o processo.
		        e.printStackTrace();
		        request.setAttribute("erro", "Erro ao cadastrar produto: " + e.getMessage());
		        request.getRequestDispatcher("erro.jsp").forward(request, response);
		    }
		}


	protected void ApagarProdutos(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String id = request.getParameter("id");
		if (id != null) {
			try {
				Produtos prod = new Produtos();
				ProdutosDAO dao = new ProdutosDAO(empresa);
				prod.setId(Integer.parseInt(id));
				dao.excluir(prod);
				response.sendRedirect("Produtos.jsp");
			} catch (Exception e) {

			}

		}
	}
	protected void atualizarProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		try {
			Produtos prod = new Produtos();
			ProdutosDAO dao = new ProdutosDAO(empresa);
			// Restante do código para setar os valores em "prod"
			prod.setId(Integer.parseInt(request.getParameter("id")));
			prod.setDescricao(request.getParameter("descricao"));

			String qtdEstoqueStr = request.getParameter("qtd_estoque");
			if (qtdEstoqueStr != null && !qtdEstoqueStr.isEmpty()) {
				prod.setQtd_estoque(Integer.parseInt(qtdEstoqueStr));
			}

			String precoCompraStr = request.getParameter("preco_de_compra");
			if (precoCompraStr != null && !precoCompraStr.isEmpty()) {
				prod.setPreco_de_compra(Double.parseDouble(precoCompraStr));
			}

			String precoVendaStr = request.getParameter("preco_de_venda");
			if (precoVendaStr != null && !precoVendaStr.isEmpty()) {
				prod.setPreco_de_venda(Double.parseDouble(precoVendaStr));
			}
			String statusstr = request.getParameter("status");
			prod.setStatus(statusstr);
			
			try {
				Part filePart = request.getPart("logo");
				if (filePart != null && filePart.getSize() > 0) {
				    try (InputStream inputStream = filePart.getInputStream()) {
				        byte[] logoBytes = inputStream.readAllBytes();
				        prod.setImagem(logoBytes);
				    }
				}
			} catch (Exception e) {
				 e.printStackTrace();
				    request.setAttribute("erro", "Erro ao cadastrar produto: " + e.getMessage());
				    request.getRequestDispatcher("erro.jsp").forward(request, response);
			}
		
				
		
			
		 
			

			String idFornecedorStr = request.getParameter("for_id");
			if (idFornecedorStr != null && !idFornecedorStr.isEmpty()) {
				Fornecedores f = new Fornecedores();
				f.setId(Integer.parseInt(idFornecedorStr));
				prod.setFornecedor(f);
			} else {
				prod.setFornecedor(null);
			}

			dao.alterarProdutos(prod);
			
			response.sendRedirect("Produtos.jsp");
			
			
		} catch (NumberFormatException e) {
			// Lide com o caso em que há um problema de formato numérico

			e.printStackTrace();
		} catch (Exception e) {
			// Lide com outras exceções não previstas

			e.printStackTrace();
		}
		
	}
	

}