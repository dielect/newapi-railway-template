# New API Railway 部署模板

一键部署 [New API](https://github.com/QuantumNous/new-api) 到 Railway 平台，自动包含 PostgreSQL 和 Redis。

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/newapi)


## 模板包含的服务

| 服务 | 说明 |
|------|------|
| **New API** | 主应用服务，基于 `calciumion/new-api:latest` 镜像 |
| **PostgreSQL** | Railway 托管 PostgreSQL 数据库 |
| **Redis** | Railway 托管 Redis 缓存 |

## 创建模板步骤

本仓库提供 New API 的应用配置（Dockerfile + railway.json）。你需要在 Railway 上创建包含三个服务的完整模板：

### 第一步：推送仓库到 GitHub

将本仓库推送到你的 GitHub（必须是 **公开仓库**）。

### 第二步：在 Railway 创建模板

1. 前往 Railway 工作区设置中的 **Templates** 页面，点击 **New Template**
2. 添加以下三个服务：

#### 服务 1：New API（主应用）

- **Source：** 选择你的 GitHub 仓库
- **Environment Variables：** 添加以下变量

  | 变量名 | 值 | 说明 |
  |--------|-----|------|
  | `SQL_DSN` | `postgres://${{Postgres.PGUSER}}:${{Postgres.PGPASSWORD}}@${{Postgres.PGHOST}}:${{Postgres.PGPORT}}/${{Postgres.PGDATABASE}}` | 引用 PostgreSQL 服务 |
  | `REDIS_CONN_STRING` | `redis://default:${{Redis.REDISPASSWORD}}@${{Redis.REDISHOST}}:${{Redis.REDISPORT}}` | 引用 Redis 服务 |
  | `SESSION_SECRET` | `${{secret(32)}}` | 自动生成 32 位随机密钥 |
  | `CRYPTO_SECRET` | `${{secret(32)}}` | 自动生成加密密钥 |
  | `TZ` | `Asia/Shanghai` | 时区 |
  | `PORT` | `3000` | 服务端口 |
  | `ERROR_LOG_ENABLED` | `true` | 启用错误日志记录 |
  | `BATCH_UPDATE_ENABLED` | `true` | 启用批量更新（生产推荐） |

#### 服务 2：PostgreSQL

- 点击 **Add Service** → **Database** → **PostgreSQL**

#### 服务 3：Redis

- 点击 **Add Service** → **Database** → **Redis**

### 第三步：发布模板

点击 **Publish**，填写模板名称和描述，发布后会获得模板链接。将链接中的模板代码替换到 README 的部署按钮 URL 中。

## 用户部署流程

模板发布后，用户只需：

1. 点击 **Deploy on Railway** 按钮
2. Railway 自动创建包含 New API + PostgreSQL + Redis 的完整项目
3. 环境变量自动关联，无需手动配置数据库连接
4. 部署完成后访问分配的公网域名，首次进入初始化页面设置管理员账号

## 架构

```
┌──────────────────────────────────────────┐
│             Railway Project              │
│                                          │
│  ┌────────────┐                          │
│  │  New API   │◄──── 公网域名             │
│  │ (Go App)   │                          │
│  └──────┬─────┘                          │
│         │                                │
│    ┌────┴─────┐                          │
│    │          │                          │
│    ▼          ▼                          │
│ ┌──────┐  ┌───────┐                     │
│ │Postgres│ │ Redis │                     │
│ │  (DB) │  │(Cache)│                     │
│ └──────┘  └───────┘                     │
└──────────────────────────────────────────┘
```

## 可选环境变量

在模板中或部署后可按需添加：

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `STREAMING_TIMEOUT` | 流式无响应超时（秒），空补全时可调大 | `120` |
| `SESSION_SECRET` | 多实例部署时必须设置为相同随机字符串 | — |
| `SYNC_FREQUENCY` | 缓存与数据库同步频率（秒） | `60` |
| `MEMORY_CACHE_ENABLED` | 启用内存缓存 | `false` |
| `BATCH_UPDATE_INTERVAL` | 批量更新间隔（秒） | `5` |
| `GLOBAL_API_RATE_LIMIT` | 全局 API 限速（3分钟/IP） | `180` |
| `GLOBAL_WEB_RATE_LIMIT` | 全局 Web 限速（3分钟/IP） | `60` |
| `RELAY_TIMEOUT` | 中继请求超时（秒） | `0` |
| `FORCE_STREAM_OPTION` | 覆盖客户端流选项 | `true` |
| `GET_MEDIA_TOKEN` | 统计图片 token | `true` |

完整环境变量列表请参考 [官方文档](https://docs.newapi.pro/zh/docs/installation/config-maintenance/environment-variables)。

## 运维操作

| 操作 | 方法 |
|------|------|
| 查看日志 | Dashboard → 选择服务 → Logs |
| 重启服务 | Dashboard → 选择服务 → Settings → Restart |
| 更新版本 | 重新触发部署，自动拉取最新镜像 |
| 扩容 | Dashboard → 选择服务 → Settings → 调整资源 |

## 参考链接

- [New API 官方文档](https://docs.newapi.pro/)
- [New API GitHub](https://github.com/QuantumNous/new-api)
- [Railway 文档](https://docs.railway.com/)
- [Railway 模板创建指南](https://docs.railway.com/guides/create)
- [Railway 模板发布指南](https://docs.railway.com/guides/publish-and-share)
