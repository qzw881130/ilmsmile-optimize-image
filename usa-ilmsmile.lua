local chunk, eof = ngx.arg[1], ngx.arg[2]
if ngx.ctx.buffered == nil then
    ngx.ctx.buffered = {}
end

ngx.log(ngx.INFO, "is_subrequest:" .. (ngx.is_subrequest and 'Y' or 'N'))

if chunk ~= "" and not ngx.is_subrequest then
    table.insert(ngx.ctx.buffered, chunk)
    ngx.arg[1] = nil
end

if eof then
    local whole = table.concat(ngx.ctx.buffered)
    ngx.ctx.buffered = nil

    local domain = ngx.var.scheme .. '://' .. ngx.var.host
    if(ngx.var.server_port ~= '80' and ngx.var.server_port ~= '443') then
        domain = domain .. ':' .. ngx.var.server_port
    end

    ngx.log(ngx.INFO, "site: usa-lua:" .. domain)
    ngx.log(ngx.INFO, "current-uri:" .. ngx.var.uri)

    if(ngx.var.uri == "/EN/static/js/web.js") then
        whole = string.gsub(whole, '(autoplay: {.-},)', "")
        whole = string.gsub(whole, '(loop: true,)', "loop: false,")
    end

    if(ngx.var.uri == "/") then
        whole = string.gsub(whole, '(<a href="/en/solution/template/luomu/" class="f16 sec_more product_more">)', '<a href="/en/solution/template/luomu/" class="f24 sec_more product_more">');
    end


    whole = string.gsub(whole, '(.jpg)', ".jpg.webp")
    whole = string.gsub(whole, '(.png)', ".png.webp")
    whole = string.gsub(whole, '(.jpeg)', ".jpeg.webp")
    whole = string.gsub(whole, '(<div class="footer_copyrights">.-</div>)', "")
    whole = string.gsub(whole, '(<span class="f16 news_rec_time">.-</span>)', "")

    ngx.log(ngx.INFO, "Host: " .. ngx.req.get_headers()["Host"])
    whole = string.gsub(whole, '(<link type="text/css" rel="stylesheet" href=")', '<link type="text/css" rel="stylesheet" href="' .. ngx.header.cssbaseurl)
    whole = string.gsub(whole, '(<script type="text/javascript" src=")', '<script type="text/javascript" src="' .. ngx.header.jsbaseurl)


    if(ngx.var.uri == "/en/solution/template/DrTortho/") then
        whole = string.gsub(whole, '(</head>)', '<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/hls.js@1"></script></head>');
        local videodom = [[
            <section class="sec_box product_box" style="background-color: #f4f6f7;">
			<div class="clearfix inner">
				<div class="product_pic" style="width: 100%%">
					<div class="product_pic_range">
                    <video id="video" controls crossorigin="true" width="100%%" preload="auto" poster="/videos/31_1694437232.jpg"></video>
                    <script>
                        var video = document.getElementById('video');
                        var videoSrc = '/videos/31_1694437232/v.m3u8';
                        if (Hls.isSupported()) {
                            var hls = new Hls();
                            hls.loadSource(videoSrc);
                            hls.attachMedia(video);
                        }
                    </script>
					</div>
				</div>
			</div>
		</section>
        ]]
        whole = string.gsub(whole, '(<section class="sec_box product_box product_even ">)', videodom .. '<section class="sec_box product_box product_even ">');
    end

    if(ngx.var.uri == "/en/solution/template/BiomechanicalSimulation/") then
        whole = string.gsub(whole, '(</head>)', '<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/hls.js@1"></script></head>');
        local videodom = [[
            <section class="sec_box product_box" style="background-color: #f4f6f7;">
			<div class="clearfix inner">
				<div class="product_pic" style="width: 100%%">
					<div class="product_pic_range">
                        <video id="video" controls crossorigin="true" width="100%%" preload="auto" poster="/videos/30_1694437228.jpg"></video>
                        <script>
                            var video = document.getElementById('video');
                            var videoSrc = '/videos/30_1694437228/v.m3u8';
                            if (Hls.isSupported()) {
                                var hls = new Hls();
                                hls.loadSource(videoSrc);
                                hls.attachMedia(video);
                            }else{

                            }
                        </script>
					</div>
				</div>
			</div>
		</section>
        ]]
        whole = string.gsub(whole, '(</main>)', videodom .. '</main>');
    end

    ngx.arg[1] = whole
    ngx.arg[2] = true

    ngx.log(ngx.INFO, "length:" .. string.len(whole))
end