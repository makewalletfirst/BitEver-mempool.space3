# BitEver Mempool Explorer (BEC)

> A highly visual, real-time mempool fee auditor and block template visualizer based on **mempool.space**, tailored specifically for the **BitEver (BEC)** L1 educational network.

---

## 🌟 What is BitEver?

**BitEver (BEC)** is a Bitcoin L1 hard fork designed for **blockchain education and hands-on learning**. The network launched independently from Bitcoin block **#478,559** (forking at the same point as Bitcoin Cash, #478,558), maintaining the exact consensus logic, halving policy, and 21 Million issuance limit as mainnet Bitcoin, with only network magic bytes customized.

---

## 🔍 The Role of Mempool in BitEver Ecosystem

While basic RPC explorers give static ledger snapshots and Electrs serves wallet lookups, the **Mempool Explorer** specializes in tracking the "unconfirmed" live state of the network.

- **Block Candidate Templates**: Projects pending transactions visually as upcoming block templates so users see exactly how miners package their transactions.
- **Gas / Fee Rates Auditing**: Dynamically groups transactions by fee rates (sat/vB, or in this network, ever/vB) to help users estimate optimal transaction fees.
- **Transaction Memory Visualization**: Renders fee rate histograms, memory usage pools, and pending queues in real-time.

---

## 🛠️ Technology Stack

- **Frontend**: Angular, TypeScript, RxJS, Sass (pre-built on Docker image `silverruler/bitever-mempool-frontend:v2.3`)
- **Backend API**: TypeScript, Node.js (Mempool Backend Engine)
- **Database**: MariaDB (caching historical graphs and mempool metrics)
- **Asset Customizations**: Custom BEC icons and logos (`bitever-favicon.png` / `bitever-favicon.svg`) mapped as container volumes.
- **Deployment**: Docker Compose

---

## 🚀 Build & Run Instructions

### Prerequisites
1. A synchronized BitEver Node (`bitcoind` RPC port: `8334`).
2. An active BitEver Electrum Indexer (`electrs` port: `50001`).

### Deployment via Docker Compose

The simplest and recommended way to deploy the mempool suite is using the bundled `docker-compose.yml` file, which maps DB, API, and the specialized Web Frontend.

1. **Verify Docker Compose Configuration**:
   ```bash
   docker compose config
   ```
2. **Review Environment Settings**:
   Inside `docker-compose.yml`, verify the connections under the `mempool-api` service:
   ```yaml
   CORE_RPC_HOST: host.docker.internal   # Point to the BitEver node host
   CORE_RPC_PORT: 8334                   # BitEver custom RPC port
   CORE_RPC_USERNAME: user               # Daemon RPC user
   CORE_RPC_PASSWORD: pass               # Daemon RPC password
   ELECTRUM_HOST: host.docker.internal   # Point to the Electrs Indexer host
   ELECTRUM_PORT: 50001                  # Electrs Electrum TCP port
   ```
3. **Launch Stack**:
   ```bash
   docker compose up -d
   ```
   This spins up `mempool_db`, `mempool_api`, and `mempool_web` in the background.

4. **Verify Container States**:
   Check if all components remain successfully running:
   ```bash
   docker ps
   ```

---

## ⚠️ Important Considerations / Caveats

- **Double Daemon Connections**: Mempool relies on both the JSON-RPC interface of `bitcoind` (for raw blocks and mempool dumps) AND the TCP interface of `electrs` (for fast address script queries). Ensure both ports (`8334` and `50001`) are reachable from within the docker containers.
- **Database Warmup**: On the first start, MariaDB needs time to initialize tables, and the API backfills historical charts. Give it up to 60 seconds before testing the web interface.
- **Custom Branding**: The logo and favicon mapping paths are explicitly mounted as volumes to ensure UI consistency without needing deep angular recompilations.

---

## 🤝 Contribution & License

Open-source customization derived from [mempool/mempool](https://github.com/mempool/mempool). Custom alterations are under the GNU GPL v3 License.
