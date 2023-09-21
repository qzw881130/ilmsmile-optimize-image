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

    if(ngx.var.uri == "/EN/contact/") then
        whole = string.gsub(whole, '(<div class="clearfix inner inner_w2">.-</div>.-</section>)', [[
            <div class="clearfix inner inner_w2">
            <iframe src="/contact-us/" title="Contact Us"  onload='javascript:(function(o){o.style.height=o.contentWindow.document.body.scrollHeight+"px";}(this));' style="height:200px;width:100%%;border:none;overflow:hidden;"></iframe>
            </div></section>
        ]]);
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
                    <video id="video" controls crossorigin="true" playsInline width="100%%" preload="auto" poster="/videos/31_1694437232.jpg"></video>
                    <script>
                        var video = document.getElementById('video');
                        var videoSrc = '/videos/31_1694437232/v.m3u8';
                        if (Hls.isSupported()) {
                            var hls = new Hls();
                            hls.loadSource(videoSrc);
                            hls.attachMedia(video);
                        }else{
                            video.innerHTML = `<source id='mp4' src="/videos/31_1694437232.mp4" type='video/mp4' />
                            <source id='webm' src="/videos/31_1694437232.webm" type='video/webm' />
                            <source id='ogv' src="/videos/31_1694437232.ogv" type='video/ogg' />
                            <p>Your user agent does not support the HTML5 Video element.</p>`;
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
                        <video id="video" controls crossorigin="true" playsInline width="100%%" preload="auto" poster="/videos/30_1694437228.jpg"></video>
                        <script>
                            var video = document.getElementById('video');
                            var videoSrc = '/videos/30_1694437228/v.m3u8';
                            if (Hls.isSupported()) {
                                var hls = new Hls();
                                hls.loadSource(videoSrc);
                                hls.attachMedia(video);
                            }else{
                                video.innerHTML = `<source id='mp4' src="/videos/30_1694437228.mp4" type='video/mp4' />
                                <source id='webm' src="/videos/30_1694437228.webm" type='video/webm' />
                                <source id='ogv' src="/videos/30_1694437228.ogv" type='video/ogg' />
                                <p>Your user agent does not support the HTML5 Video element.</p>`;
                            }
                        </script>
					</div>
				</div>
			</div>
		</section>
        ]]
        whole = string.gsub(whole, '(</main>)', videodom .. '</main>');
        whole = string.gsub(whole, '(oral doctors)', 'dentists');
    end

    ngx.arg[1] = whole
    ngx.arg[2] = true

    ngx.log(ngx.INFO, "length:" .. string.len(whole))
end