import os
import MySQLdb
from http.server import SimpleHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

def conectar_banco():
    """Função para conectar ao banco de dados MySQL."""
    try:
        conn = MySQLdb.connect(
            host="localhost",
            user="root",
            password="senai",
            db="filmes_db"
        )
        print("Conexão com o banco de dados bem-sucedida!")
        return conn
    except MySQLdb.Error as err:
        print(f"Erro ao conectar ao banco de dados: {err}")
        return None

def buscar_filmes_do_banco():
    """Busca todos os filmes e suas informações relacionadas do banco de dados."""
    conn = conectar_banco()
    if conn is None:
        return []

    cursor = conn.cursor(MySQLdb.cursors.DictCursor)
    query = """
    SELECT 
        F.id_filme, F.titulo, F.ano_de_lancamento, F.tempo_de_duracao,
        GROUP_CONCAT(DISTINCT A.nome SEPARATOR ', ') AS atores,
        GROUP_CONCAT(DISTINCT D.nome, ' ', D.sobrenome SEPARATOR ', ') AS diretores,
        GROUP_CONCAT(DISTINCT G.nome SEPARATOR ', ') AS generos,
        GROUP_CONCAT(DISTINCT P.nome SEPARATOR ', ') AS produtoras
    FROM Filme F
    LEFT JOIN Filme_ator FA ON F.id_filme = FA.id_filme
    LEFT JOIN Ator A ON FA.id_ator = A.id_ator
    LEFT JOIN filme_diretor FD ON F.id_filme = FD.id_filme
    LEFT JOIN Diretor D ON FD.id_diretor = D.id_diretor
    LEFT JOIN Filme_genero FG ON F.id_filme = FG.id_filme
    LEFT JOIN genero G ON FG.id_genero = G.id_genero
    LEFT JOIN filme_produtora FP ON F.id_filme = FP.id_filme
    LEFT JOIN Produtora P ON FP.id_produtora = P.id_produtora
    GROUP BY F.id_filme;
    """
    try:
        cursor.execute(query)
        filmes = cursor.fetchall()
        return filmes
    except MySQLdb.Error as err:
        print(f"Erro ao buscar filmes: {err}")
        return []
    finally:
        cursor.close()
        conn.close()

def adicionar_filme_no_banco(dados_filme):
    """Adiciona um novo filme à tabela Filme."""
    conn = conectar_banco()
    if conn is None:
        return False
    
    cursor = conn.cursor()
    query = "INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao) VALUES (%s, %s, %s)"
    
    try:
        titulo = dados_filme.get('filme-nome', [''])[0]
        ano = dados_filme.get('filme-ano', [None])[0]
        duracao = dados_filme.get('filme-duracao', [None])[0] 
        
        # Converte para int ou None se estiver vazio
        ano_int = int(ano) if ano else None
        duracao_int = int(duracao) if duracao else None

        cursor.execute(query, (titulo, ano_int, duracao_int))
        conn.commit()
        print(f"Filme '{titulo}' adicionado com sucesso!")
        return True
    except (MySQLdb.Error, ValueError) as err: # Captura erro de conversão (ex: 'abc' para int)
        print(f"Erro ao adicionar filme: {err}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close()

def deletar_filme_do_banco(filme_id):
    """Remove um filme e todas as suas associações do banco de dados."""
    conn = conectar_banco()
    if conn is None:
        return False
    
    cursor = conn.cursor()
    try:
        # Deleta primeiro as referências nas tabelas de junção
        cursor.execute("DELETE FROM Filme_ator WHERE id_filme = %s", (filme_id,))
        cursor.execute("DELETE FROM filme_diretor WHERE id_filme = %s", (filme_id,))
        cursor.execute("DELETE FROM Filme_genero WHERE id_filme = %s", (filme_id,))
        cursor.execute("DELETE FROM filme_produtora WHERE id_filme = %s", (filme_id,))
        cursor.execute("DELETE FROM filme_linguagem WHERE id_filme = %s", (filme_id,))
        cursor.execute("DELETE FROM Filme_pais WHERE id_filme = %s", (filme_id,))
        
        # Agora deleta o filme principal
        cursor.execute("DELETE FROM Filme WHERE id_filme = %s", (filme_id,))
        
        conn.commit()
        print(f"Filme com ID {filme_id} removido com sucesso!")
        return True
    except MySQLdb.Error as err:
        print(f"Erro ao deletar filme: {err}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close()


class MyHandle(SimpleHTTPRequestHandler):
    
    def list_directory(self, path):
        try:
            f = open(os.path.join(path, 'index.html'), 'r', encoding="utf-8")
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(f.read().encode('utf-8'))
            f.close()
            return None
        except FileNotFoundError:
            pass
        return super().list_directory(path)
    
    def do_GET(self):
        # Parse da URL para pegar a rota e os parâmetros
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        query_params = parse_qs(parsed_path.query)

        # Lógica para o css
        if path.endswith(".css"):
            try:
                with open(os.path.join(os.getcwd(), path.lstrip('/')), 'r', encoding="utf-8") as css_file:
                    content = css_file.read()
                self.send_response(200)
                self.send_header("Content-type", "text/css")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Arquivo CSS não encontrado.")
            return

        # Lógica para a página de login
        if path == "/login":
            try:
                with open(os.path.join(os.getcwd(), "login.html"), 'r', encoding="utf-8") as login:
                    content = login.read()
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Página não encontrada, tente novamente mais tarde.")
            return
                
        # Lógica para a página de cadastro 
        elif path == "/cadastro":
            try:
                with open(os.path.join(os.getcwd(), "cadastro.html"), 'r', encoding="utf-8") as cadastro:
                    content = cadastro.read()
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Essa página de cadastro não existe!")
            return

        # lógica para a lista de filmes (do banco)
        elif path == "/listar_filmes":
            try:
                with open(os.path.join(os.getcwd(), "listar_filmes.html"), 'r', encoding="utf-8") as f:
                    content = f.read()
                
                filmes_do_banco = buscar_filmes_do_banco()
                
                filmes_html = ""
                if not filmes_do_banco:
                    filmes_html = "<p class='mensagem-vazia'>Nenhum filme encontrado no banco de dados.</p>"
                else:
                    for filme in filmes_do_banco:
                        filmes_html += f"""
                        <div class='card-filme'>
                            <h2>{filme.get('titulo', 'N/A')}</h2>
                            <p><strong>Ano:</strong> {filme.get('ano_de_lancamento', 'N/A')}</p>
                            <p><strong>Atores:</strong> {filme.get('atores', 'N/A')}</p>
                            <p><strong>Diretor(es):</strong> {filme.get('diretores', 'N/A')}</p>
                            <p><strong>Gênero:</strong> {filme.get('generos', 'N/A')}</p>
                            <p><strong>Produtora(s):</strong> {filme.get('produtoras', 'N/A')}</p>
                            <p><strong>Duração:</strong> {filme.get('tempo_de_duracao', 'N/A')} min</p>
                            <div class="card-botoes">
                                <a href="/editar_filme?id={filme['id_filme']}" class="botao-card botao-editar">Editar</a>
                                <a href="/deletar_filme?id={filme['id_filme']}" class="botao-card botao-remover" onclick="return confirm('Tem certeza que deseja remover este filme?');">Remover</a>
                            </div>
                        </div>
                        """
                
                content = content.replace('{{LISTA_FILMES}}', filmes_html)
                
                self.send_response(200)
                self.send_header("Content-type", "text/html; charset=utf-8")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))

            except Exception as e:
                self.send_error(500, f"Erro no servidor: {e}")
        
        # lógica para deletar
        elif path == "/deletar_filme":
            filme_id = query_params.get('id', [None])[0]
            if filme_id:
                deletar_filme_do_banco(filme_id)
            self.send_response(302)
            self.send_header('Location', '/listar_filmes')
            self.end_headers()

        elif path == "/editar_filme":
            filme_id = query_params.get('id', [None])[0]
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            response_html = f"""
            <html>
                <head><title>Editar Filme</title></head>
                <body>
                    <h1>Página de Edição</h1>
                    <p>Funcionalidade de editar o filme com ID {filme_id} ainda não implementada.</p>
                    <a href="/listar_filmes">Voltar para a lista</a>
                </body>
            </html>
            """
            self.wfile.write(response_html.encode('utf-8'))
        
        else:
             super().do_GET()

    def do_POST(self):
        if self.path == '/cadastrar_filme':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            dados_formulario = parse_qs(post_data.decode('utf-8'))
            
            # Chama a função para adicionar ao banco de dados
            adicionar_filme_no_banco(dados_formulario)
            
            self.send_response(302)
            self.send_header('Location', '/listar_filmes')
            self.end_headers()
        else:
            self.send_error(404, "Rota POST não encontrada.")

def main():
    server_address = ('', 8000)
    httpd = HTTPServer(server_address, MyHandle)
    print("Servidor rodando em http://localhost:8000")
    httpd.serve_forever()

if __name__ == '__main__':
    main()