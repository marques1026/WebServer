import os
from http.server import SimpleHTTPRequestHandler, HTTPServer

# cria a própria versão do servidor
class MyHandle(SimpleHTTPRequestHandler):
    
    # mostra a página 'index.html' que estiver dentro dela
    def list_directory(self, path):
        try:
            #tnta achar e abrir o arquivo 'index.html' na pasta que o usuário pediu
            f = open(os.path.join(path, 'index.html'), 'r', encoding="utf-8")

            # Se achou o arquivo, responde que deu tudo certo (código 200)
            self.send_response(200)
            # Avisa o navegador q ta mandando um arquivo HTML
            self.send_header("Content-type", "text/html")
            self.end_headers()
            # manda o conteúdo do 'index.html' pro navegador
            # usando utf-8 pra não ter problema com acento
            self.wfile.write(f.read().encode('utf-8'))
            # fecha o arquivo
            f.close()
            return None
        except FileNotFoundError:
            # se não existir um 'index.html' na pasta, o servidor faz o de sempre (listar os arquivos)
            pass
        return super().list_directory(path)
    
 # cuida das requisições GET 
    def do_GET(self):
        # Se o usuário acessar o endereço "/login"
        if self.path == "/login":
            try:
                #  tenta abrir o arquivo 'login.html'
                with open(os.path.join(os.getcwd(), "login.html"), 'r', encoding="utf-8") as login:
                    content = login.read()
                # se der certo manda o código 200 e o conteúdo da página
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                # se não achou o arquivo mostra o erro 404
                self.send_error(404, "Página não encontrada, tente novamente mais tarde.")
                
        # se o usuário acessar o endereço "/cadastro" isso acontece
        elif self.path == "/cadastro":
            try:
                # tenta abrir o 'cadastro.html'
                with open(os.path.join(os.getcwd(), "cadastro.html"), 'r', encoding="utf-8") as cadastro:
                    content = cadastro.read()
                # envia a pagina pra ele
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                # se n for, da erro 404
                self.send_error(404, "Essa página de cadastro não existe, foi mal!")

        # se o usuário acessar "/listar_filmes"
        elif self.path == "/listar_filmes":
            try:
                # procura a pagina "listar filmes"
                with open(os.path.join(os.getcwd(), "listar_filmes.html"), 'r', encoding="utf-8") as filmes:
                    content = filmes.read()
                # se achar a página
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                # se não achar
                self.send_error(404, "Não achei a lista de filmes!")
                
        # Se não for nenhuma das URLs especiais que foram definidas
        else:
            # o servidor padrão cuida do resto
            super().do_GET()

# coloca o servidor pra rodar
def main():
    server_address = ('', 8000) # roda o servidor na porta 8080
    httpd = HTTPServer(server_address, MyHandle)  # criando o servidor
    print("Servidor rodando em http://localhost:8000") # Avisa no terminal que o servidor está no ar e onde acessar
    httpd.serve_forever() # liga o servidor e fica esperando requisições

# inicia o servidor
main() 