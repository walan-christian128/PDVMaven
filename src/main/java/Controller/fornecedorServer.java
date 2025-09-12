package Controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;

import DAO.FornecedoresDAO;
import Model.Fornecedores;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class fornecedorServer
 */
@WebServlet(urlPatterns = { "/insertFornecedor", "/atualizarFornecedor", "/selectFornecedor","/apagar"})
public class fornecedorServer extends HttpServlet {
	private static final long serialVersionUID = 1L;




	public fornecedorServer() {
		super();
	
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());

		// Construir um objeto JSON com os dados do fornecedor

		String action = request.getServletPath();
		System.out.println(action);
		 if (action.equals("/insertFornecedor")) {
		        try {
					CadastrarFornecedor(request, response);
				} catch (ClassNotFoundException | ServletException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    } else if (action.equals("/atualizarFornecedor")) {
		        try {
					atualizarFornecedor(request, response);
				} catch (ClassNotFoundException | ServletException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    } else if (action.equals("/selectFornecedor")) {
		        try {
					modalSelect(request, response);
				} catch (ClassNotFoundException | ServletException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    }
		    else if (action.equals("/apagar")) {
		        try {
					apagarFornecedor(request, response);
				} catch (ClassNotFoundException | ServletException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    }

	}

	private void apagarFornecedor(HttpServletRequest request, HttpServletResponse response)	throws ServletException, IOException, ClassNotFoundException, SQLException, NamingException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String idFornecedor = request.getParameter("id");
		Fornecedores obj = new Fornecedores();
		FornecedoresDAO dao = new FornecedoresDAO(empresa);
		String id = request.getParameter("id");

		if(id != null) {
			obj.setId(Integer.parseInt(id));
			dao.excluirFornecedores(obj);
			response.sendRedirect("Fornecedores.jsp");

		}

	}

	private void modalSelect(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, ClassNotFoundException, SQLException, NamingException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String idFornecedor = request.getParameter("id");
		Fornecedores obj = new Fornecedores();
		FornecedoresDAO dao = new FornecedoresDAO(empresa);

		try {
			obj.setId(Integer.parseInt(idFornecedor));
			dao.modalFornecedores(obj);
			request.setAttribute("id", obj.getId());
			request.setAttribute("nome", obj.getNome());
			request.setAttribute("cnpj", obj.getCnpj());
			request.setAttribute("email", obj.getEmail());
			request.setAttribute("celular", obj.getCelular());
			request.setAttribute("telefone", obj.getTelefone());
			request.setAttribute("cep", obj.getCep());
			request.setAttribute("endereco", obj.getEndereco());
			request.setAttribute("numero", obj.getNumero());
			request.setAttribute("bairro", obj.getBairro());
			request.setAttribute("cidade", obj.getCidade());
			request.setAttribute("complemento", obj.getComplemento());
			request.setAttribute("estado", obj.getUf());

			RequestDispatcher rd = request.getRequestDispatcher("EditarFornecedor.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {



		// TODO Auto-generated method stub
		doGet(request, response);
	}

	private void atualizarFornecedor(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, ClassNotFoundException, SQLException, NamingException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String idFornecedor = request.getParameter("id");
		Fornecedores obj = new Fornecedores();
		FornecedoresDAO dao = new FornecedoresDAO(empresa);
		try {
			String idFornec = request.getParameter("id");
			if (idFornec != null && !idFornec.trim().isEmpty()) {
				obj.setId(Integer.parseInt(idFornec));
			}
			String nomeFornec = request.getParameter("nome");
			if (nomeFornec != null && !nomeFornec.trim().isEmpty()) {
				obj.setNome(nomeFornec);
			}
			String cnpjFornec = request.getParameter("cnpj");
			if (cnpjFornec != null && !cnpjFornec.trim().isEmpty()) {
				obj.setCnpj(cnpjFornec);
			}
			String emailFornec = request.getParameter("email");
			if (emailFornec != null && !emailFornec.trim().isEmpty()) {
				obj.setEmail(emailFornec);
			}
			String telefoneFornec = request.getParameter("telefone");
			if (telefoneFornec != null && !telefoneFornec.trim().isEmpty()) {
				obj.setTelefone(telefoneFornec);
			}
			String celularFornec = request.getParameter("celular");
			if (celularFornec != null && !celularFornec.trim().isEmpty()) {
				obj.setCelular(celularFornec);
			}
			String cepFornec = request.getParameter("cep");
			if (cepFornec != null && !cepFornec.trim().isEmpty()) {
				obj.setCep(cepFornec);
			}

			String enderecoFornec = request.getParameter("endereco");
			if (enderecoFornec != null && !enderecoFornec.trim().isEmpty()) {
				obj.setEndereco(enderecoFornec);
			}
			String numeroFornec = request.getParameter("numero");
			if (numeroFornec != null && !numeroFornec.trim().isEmpty()) {
				obj.setNumero(Integer.parseInt(numeroFornec));
			}
			String complementoFornec = request.getParameter("complemento");
			if (complementoFornec != null && !complementoFornec.trim().isEmpty()) {
				obj.setComplemento(complementoFornec);
			}
			String bairroFornec = request.getParameter("bairro");
			if (bairroFornec != null && !bairroFornec.trim().isEmpty()) {
				obj.setBairro(bairroFornec);
			}

			String cidadeFornec = request.getParameter("cidade");
			if (cidadeFornec != null && !cidadeFornec.trim().isEmpty()) {
				obj.setCidade(cidadeFornec);
			}
			String estadoFornec = request.getParameter("estado");
			if (estadoFornec != null && !estadoFornec.trim().isEmpty()) {
				obj.setUf(estadoFornec);
			}
			dao.alterarFornecedores(obj);
			response.sendRedirect("Fornecedores.jsp");
		} catch (Exception e) {

		}

	}

	private void CadastrarFornecedor(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, ClassNotFoundException, SQLException, NamingException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String idFornecedor = request.getParameter("id");
		Fornecedores obj = new Fornecedores();
		FornecedoresDAO dao = new FornecedoresDAO(empresa);
		String fornecNome = request.getParameter("nome");
		if (fornecNome != null && !fornecNome.trim().isEmpty()) {
			try {

				obj.setNome(fornecNome);
				obj.setCnpj(request.getParameter("cnpj"));
				obj.setEmail(request.getParameter("email"));
				obj.setCelular(request.getParameter("celular"));
				obj.setTelefone(request.getParameter("telefone"));
				obj.setCep(request.getParameter("cep"));
				obj.setEndereco(request.getParameter("endereco"));
				obj.setNumero(Integer.parseInt(request.getParameter("numero")));
				obj.setBairro(request.getParameter("bairro"));
				obj.setCidade(request.getParameter("cidade"));
				obj.setComplemento(request.getParameter("complemento"));
				obj.setUf(request.getParameter("estado"));
				dao.cadastrarFornecedores(obj);

				response.sendRedirect("Fornecedores.jsp");

			} catch (Exception e) {

			}
		}

	}

}