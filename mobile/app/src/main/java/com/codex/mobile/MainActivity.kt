package com.codex.mobile

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    private lateinit var webView: WebView
    private lateinit var urlInput: EditText
    private lateinit var loadButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        webView = findViewById(R.id.web_view)
        urlInput = findViewById(R.id.url_input)
        loadButton = findViewById(R.id.load_button)

        configureWebView()

        val startUrl = intent.getStringExtra(EXTRA_START_URL) ?: DEFAULT_URL
        urlInput.setText(startUrl)
        loadUrl(startUrl)

        loadButton.setOnClickListener {
            val input = urlInput.text.toString().trim()
            val targetUrl = normalizeUrl(input)
            urlInput.setText(targetUrl)
            loadUrl(targetUrl)
        }

        urlInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) = Unit
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) = Unit
            override fun afterTextChanged(s: Editable?) {
                loadButton.isEnabled = !s.isNullOrBlank()
            }
        })
        loadButton.isEnabled = urlInput.text.isNotBlank()
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    private fun configureWebView() {
        webView.webViewClient = WebViewClient()
        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            loadsImagesAutomatically = true
        }
    }

    private fun loadUrl(url: String) {
        webView.loadUrl(url)
    }

    private fun normalizeUrl(input: String): String {
        if (input.isBlank()) return DEFAULT_URL
        if (input.startsWith("http://") || input.startsWith("https://")) return input
        val isLocalHost = input.startsWith("10.0.2.2") || input.startsWith("127.0.0.1") || input.contains("localhost")
        return if (isLocalHost) {
            "http://$input"
        } else {
            "https://$input"
        }
    }

    companion object {
        const val EXTRA_START_URL = "start_url"
        private const val DEFAULT_URL = "http://10.0.2.2:8000/mobile/"
    }
}
