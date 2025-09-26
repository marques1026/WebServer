import os
from http.server import SimpleHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs

# lista para armazenar os filmes na memoria
filmes_cadastrados = []

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

        if self.path.endswith(".css"):
            try:
                with open(os.path.join(os.getcwd(), self.path.lstrip('/')), 'r', encoding="utf-8") as css_file:
                    content = css_file.read()
                self.send_response(200)
                self.send_header("Content-type", "text/css")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Arquivo CSS não encontrado.")
            return

        if self.path == "/login":
            try:
                with open(os.path.join(os.getcwd(), "login.html"), 'r', encoding="utf-8") as login:
                    content = login.read()
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Página não encontrada, tente novamente mais tarde.")
                
        elif self.path == "/cadastro":
            try:
                with open(os.path.join(os.getcwd(), "cadastro.html"), 'r', encoding="utf-8") as cadastro:
                    content = cadastro.read()
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Essa página de cadastro não existe!")

        elif self.path == "/listar_filmes":
            try:
                # abre o arquivo html
                with open(os.path.join(os.getcwd(), "listar_filmes.html"), 'r', encoding="utf-8") as f:
                    content = f.read()
                
                # 2. Gera o HTML dos filmes
                filmes_html = ""
                if not filmes_cadastrados:
                    filmes_html = "<p class='mensagem-vazia'>Nenhum filme cadastrado ainda.</p>"
                else:
                    for filme in filmes_cadastrados:
                        filmes_html += f"""
                        <div class='card-filme'>
                            <h2>{filme.get('filme-nome', 'N/A')}</h2>
                            <p><strong>Atores:</strong> {filme.get('filme-atores', 'N/A')}</p>
                            <p><strong>Diretor:</strong> {filme.get('filme-diretor', 'N/A')}</p>
                            <p><strong>Ano:</strong> {filme.get('filme-ano', 'N/A')}</p>
                            <p><strong>Gênero:</strong> {filme.get('filme-genero', 'N/A')}</p>
                            <p><strong>Produtora:</strong> {filme.get('filme-produtora', 'N/A')}</p>
                            <p><strong>Sinopse:</strong> {filme.get('filme-sinopse', 'N/A')}</p>
                        </div>
                        """
                
                content = content.replace('{{LISTA_FILMES}}', filmes_html)
                
                # envia a resposta pro navegador
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))

            except FileNotFoundError:
                self.send_error(404, "Não achei a lista de filmes!")
                
                content = content.replace('', filmes_html)
                
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_error(404, "Não achei a lista de filmes!")
                
        else:
            super().do_GET()

    def do_POST(self):
        # verifica a rota da requisição POST
        if self.path == '/cadastrar_filme':
            content_length = int(self.headers['Content-Length'])
            
            post_data = self.rfile.read(content_length)
            
            dados_formulario = parse_qs(post_data.decode('utf-8'))
            
            
            novo_filme = {key: dados_formulario.get(key, [''])[0] for key in dados_formulario}
            
            filmes_cadastrados.append(novo_filme)
            
            # redireciona de volta pra página de listagem
            self.send_response(302)
            self.send_header('Location', '/listar_filmes')
            self.end_headers()
        else:
            # se a rota não for a esperada, retorna um erro
            self.send_error(404, "Rota POST não encontrada.")

def main():
    server_address = ('', 8000)
    httpd = HTTPServer(server_address, MyHandle)
    print("Servidor rodando em http://localhost:8000")
    httpd.serve_forever()

if __name__ == '__main__':
    main()