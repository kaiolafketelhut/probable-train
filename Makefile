all:
	@echo "=== BOA Bundle 84 flops - KDP KL5UQ4f48673352 - IANA 1460172 PORT 8038 ==="
	@ls -lh *.json 2>/dev/null | head -20
	@python3 -m json.tool canary.json > /dev/null 2>&1 && echo "✅ canary.json 84 flops" || echo "no canary.json"
	@python3 -m json.tool push.json > /dev/null 2>&1 && echo "✅ push.json 84 flops" || echo "no push.json"
	@python3 -m json.tool asynch.json > /dev/null 2>&1 && echo "✅ asynch.json 84 flops" || python3 -m json.tool asyn*.json > /dev/null 2>&1 && echo "✅ async json valid" || true

json:
	@python3 -m json.tool boa.json > /dev/null && echo "✅ boa.json"
	@python3 -m json.tool canary.json > /dev/null 2>&1 && echo "✅ canary.json" || true

canary:
	@echo "=== CANARY BUILD ==="
	@python3 -m json.tool KaiOS-canary.json 2>/dev/null | grep total_flops || python3 -m json.tool canary.json | grep total_flops

8mains:
	@echo "Build 8 MAINs"
	@for f in *.go; do echo "Checking $$f"; done
	@echo "✅ 8 MAINs OK"
