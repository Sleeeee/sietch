int main(string[] args) {
  Application app = new Application(){
    instance_name = "sietch",
    resource_base_path = "/com/github/sleeeee/sietch"
  };
  return app.run(args);
}
