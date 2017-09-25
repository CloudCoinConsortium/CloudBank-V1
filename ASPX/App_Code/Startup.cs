using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CloudBank.Startup))]
namespace CloudBank
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
