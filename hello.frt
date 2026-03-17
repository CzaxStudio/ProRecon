// ─────────────────────────────────────────────────────
//  Fortress Script — hello.frt
//  Created: 2026-03-15 05:10:19
// ─────────────────────────────────────────────────────

// Entry point
probe main() {
    compute("⬡ Fortress v1.1.0 — Ready")

    // Get target from user
    capture("  Target (IP/domain): ") -> target

    if target == "" {
        compute("No target provided. Exiting.")
        return
    }

    compute("")
    compute("  ► Running reconnaissance on: " -> target)
    compute("")

    // DNS Resolution
    let dns = resolve(target)
    compute("  [DNS] Resolved IPs: " -> len(dns.ips))
    each ip in dns.ips {
        compute("        └─ " -> ip)
    }

    // Geolocation
    let geo = geolocate(target)
    if geo.status == "success" {
        compute("  [GEO] " -> geo.city -> ", " -> geo.regionName -> " — " -> geo.country)
        compute("        ISP: " -> geo.isp)
        compute("        ASN: " -> geo.as)
        compute("        Coords: " -> str(geo.lat) -> ", " -> str(geo.lon))
    }

    // Port scan
    let scan = portscan(target)
    compute("  [SCAN] " -> scan.open_count -> " open ports (of " -> scan.scanned -> " scanned)")
    each port in scan.open {
        compute("        └─ " -> str(port.port) -> "/tcp  " -> port.service)
    }

    // Generate report
    report "Recon Report" as "text" {
        target: target,
        open_ports: scan.open_count,
        country: geo.country,
        isp: geo.isp,
        scanned_at: now()
    }
}

main()
