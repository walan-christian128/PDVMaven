package Controller;

import java.io.IOException;

import DAO.UsuarioDAO;
import Model.Empresa;
import Model.Usuario;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class userLogin
 */
@WebServlet(name = "Login.jsp", urlPatterns = { "/logar" })
public class userLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String MASTER_EMAIL_FIXO = "dbawttech@gmail.com";
    private static final String MASTER_SENHA_FIXA = "dbawttech@!"; 
    private static final String MASTER_NIVEL = "ROOT_MASTER";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String empresa = request.getParameter("empresa");

        if (email == null || email.isEmpty() || senha == null || senha.isEmpty() || empresa == null || empresa.isEmpty()) {
            request.setAttribute("erro", "Todos os campos devem ser preenchidos.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        String nomeBase = empresa.trim().toLowerCase();
        HttpSession session = request.getSession();

        // --- 1. LOGIN MASTER ---
        if (email.equals(MASTER_EMAIL_FIXO) && senha.equals(MASTER_SENHA_FIXA)) {
            try {
                new UsuarioDAO(nomeBase); 
                
                Usuario master = new Usuario();
                master.setId(1); // ID fixo para o Master
                master.setEmail(MASTER_EMAIL_FIXO);
                master.setNome("Master do Sistema");
                master.setNivel(MASTER_NIVEL);
                
                Empresa empMaster = new Empresa();
                empMaster.setNome(nomeBase);
                master.setEmpresa(empMaster);

                // --- PADRONIZAÇÃO DE SESSÃO ---
                session.setAttribute("usuario", master);      // Para a Home.jsp
                session.setAttribute("usuarioID", master.getId()); // Para o Servlet de Vendas
                session.setAttribute("empresa", nomeBase);    // Para todos os DAOs
                
                response.sendRedirect("Home.jsp");
                return;
            } catch (Exception e) {
                request.setAttribute("erro", "Base de dados inexistente ou erro de conexão.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }
        } 
        
        // --- 2. LOGIN CLIENTE COMUM ---
        else {
            try {
                UsuarioDAO dao = new UsuarioDAO(nomeBase);
                boolean loginValido = dao.efetuarLogin(email, senha, nomeBase);

                if (!loginValido) {
                    request.setAttribute("erro", "Usuário, senha ou empresa incorretos.");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                    return;
                }

                Usuario credenciais = new Usuario();
                credenciais.setEmail(email);
                credenciais.setSenha(senha);

                int idGerado = dao.cidugoUsuario(credenciais, nomeBase);
                
                if (idGerado > 0) {
                    Usuario usuarioLogado = dao.retornUser(credenciais, nomeBase, idGerado); 

                    if (usuarioLogado != null) {
                        // --- PADRONIZAÇÃO DE SESSÃO ---
                        // Aqui garantimos que tanto o Objeto quanto o ID existam na sessão
                        session.setAttribute("usuario", usuarioLogado);      // Resolve o erro da Home.jsp
                        session.setAttribute("usuarioID", usuarioLogado.getId()); // Resolve o erro do Servlet de Vendas
                        session.setAttribute("empresa", nomeBase);           // Resolve o erro de conexão dos DAOs
                        
                        response.sendRedirect("Home.jsp");
                    } else {
                        request.setAttribute("erro", "Dados do usuário não encontrados.");
                        request.getRequestDispatcher("Login.jsp").forward(request, response);
                    }
                }
            } catch (Exception e) {
                request.setAttribute("erro", "Erro ao acessar a base de dados.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }
        }
    }
}
