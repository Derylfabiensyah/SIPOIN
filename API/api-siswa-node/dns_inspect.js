const dns = require('dns').promises;

async function inspect() {
  const domains = [
    'nnbzczuxejlnvjfkkhdp.supabase.co',
    'db.nnbzczuxejlnvjfkkhdp.supabase.co'
  ];

  for (const domain of domains) {
    console.log(`\n=== Inspecting ${domain} ===`);
    
    // Resolve A
    try {
      const a = await dns.resolve4(domain);
      console.log('A records:', a);
    } catch (e) {
      console.log('A error:', e.message);
    }

    // Resolve AAAA
    try {
      const aaaa = await dns.resolve6(domain);
      console.log('AAAA records:', aaaa);
    } catch (e) {
      console.log('AAAA error:', e.message);
    }

    // Resolve CNAME
    try {
      const cname = await dns.resolveCname(domain);
      console.log('CNAME records:', cname);
    } catch (e) {
      console.log('CNAME error:', e.message);
    }

    // Resolve TXT
    try {
      const txt = await dns.resolveTxt(domain);
      console.log('TXT records:', txt);
    } catch (e) {
      console.log('TXT error:', e.message);
    }

    // Resolve SRV
    try {
      const srv = await dns.resolveSrv(domain);
      console.log('SRV records:', srv);
    } catch (e) {
      console.log('SRV error:', e.message);
    }
  }
}

inspect();
